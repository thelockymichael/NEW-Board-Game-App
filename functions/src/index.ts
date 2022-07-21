/* eslint-disable no-plusplus */
/* eslint-disable arrow-body-style */
/* eslint-disable no-multi-spaces */
/* eslint-disable import/no-import-module-exports */
import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import cors from 'cors'
import express, { Request, Response } from 'express'
import { ResultAppUser } from './types/ResultAppUser'

const app = express()
app.use(express.json())
app.use(express.urlencoded())

admin.initializeApp()

app.use(cors({ origin: true }))

// TODO Convert searchPhotographers to express function

const db = admin.firestore()
function deg2rad(deg: number) {
  return deg * (Math.PI / 180)
}

function getDistanceFromLatLonInKm(lat1: number, lon1: number, lat2: number, lon2: number) {
  const R = 6371 // Radius of the earth in km
  const dLat = deg2rad(lat2 - lat1) // deg2rad below
  const dLon = deg2rad(lon2 - lon1)
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
    + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2))
    * Math.sin(dLon / 2) * Math.sin(dLon / 2)

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  const d = R * c // Distance in km
  return d
}

// Function call
function findCommonElements(arr1: Array<string>, arr2: Array<string>) {
  // Create an empty object
  const obj: any = {}

  // Loop through the first array
  for (let i = 0; i < arr1.length; i++) {
    // Check if element from first array
    // already exist in object or not
    if (!obj[arr1[i]]) {
      // If it doesn't exist assign the
      // properties equals to the
      // elements in the array
      const element = arr1[i]
      obj[element] = true
    }
  }

  // Loop through the second array
  for (let j = 0; j < arr2.length; j++) {
    // Check elements from second array exist
    // in the created object or not
    if (obj[arr2[j]]) {
      return true
    }
  }
  return false
}

function roundNearest10(num: number) {
  return Math.round(num / 10) * 10
}

exports.getNearestUsers = functions.https.onRequest(
  async (req: Request, res: Response) => {
    const lat = req.query.lat as unknown as number
    const long = req.query.long as unknown as number
    const gender = req.query.gender as unknown as string
    const minAge = req.query.minAge as unknown as number
    const maxAge = req.query.maxAge as unknown as number
    const distance = req.query.distance as unknown as string
    const limit = parseInt(req.query.limit as unknown as string, 10)

    let bgMechanics = req.query.bgMechanics  as unknown as Array<string>
    let bgThemes = req.query.bgThemes  as unknown as Array<string>
    let languages = req.query.languages  as unknown as Array<string>
    let localities = req.query.localities  as unknown as Array<string>

    let ignoreIds = req.query.ignoreId as unknown as Array<string>

    if (!Array.isArray(ignoreIds)) {
      ignoreIds = [ignoreIds]
    }

    if (bgMechanics !== undefined && !Array.isArray(bgMechanics)) {
      bgMechanics = [bgMechanics]
    }

    if (bgThemes !== undefined && !Array.isArray(bgThemes)) {
      bgThemes = [bgThemes]
    }

    if (languages !== undefined && !Array.isArray(languages)) {
      languages = [languages]
    }

    if (localities !== undefined && !Array.isArray(localities)) {
      localities = [localities]
    }

    const usersRef: admin.firestore.Query<admin.firestore.DocumentData> = db
      .collection('users')
      .limit(limit)
      .orderBy('updatedAt', 'desc')

    const users = await usersRef.get()

    const newPromise: Array<ResultAppUser> = await new Promise((resolve, reject) => {
      const tmpUsers:Array<ResultAppUser> = []

      users.docs.forEach((doc) => {
        const user = doc.data() as ResultAppUser

        const ignoreIdExists = ignoreIds.some((ignoreId) => user.id === ignoreId)
        if (ignoreIdExists) {
          return
        }

        // 1. My user
        const myUserLat: number = lat as unknown as number
        const myUserLong: number = long as unknown as number
        // 2. Other user
        const otherLat = user.currentGeoLocation.latitude
        const otherLong = user.currentGeoLocation.longitude

        const distanceFromMyUser = getDistanceFromLatLonInKm(
          myUserLat,
          myUserLong,
          otherLat,
          otherLong,
        )

        const date = new Date(0)
        date.setMilliseconds(user.age)

        const userAge = new Date().getFullYear() - date.getFullYear()

        // Check if user's age is in range.
        if (userAge >= minAge && userAge <= maxAge) {
          let containsMechanics = false
          let containsThemes = false
          const containsLanguages = false
          let containsLocalities = false

          if (bgMechanics || bgThemes || languages || localities) {
            if (containsMechanics) {
              containsMechanics = findCommonElements(user.favBgMechanics, bgMechanics)
            }

            if (containsThemes) {
              containsThemes = findCommonElements(user.favBgThemes, bgThemes)
            }

            if (containsLanguages) {
              containsThemes = findCommonElements(user.languages, languages)
            }

            if (containsLocalities) {
              containsLocalities = findCommonElements([user.currentLocation], localities)
            }

            // IF 'More Options' DO exist (bgMechanics, bgThemes, localities, localities)
            if (containsMechanics || containsThemes || containsLanguages || containsLocalities) {
              if (user.gender === gender) {
                tmpUsers.push({
                  ...user,
                  distance: distanceFromMyUser,
                })
              } else if (gender === 'everyone') {
                tmpUsers.push({
                  ...user,
                  distance: distanceFromMyUser,
                })
              }
            }

            // IF 'More Options' DO NOT exist (bgMechanics, bgThemes, languages, localities)
          } else if (user.gender === gender) {
            tmpUsers.push({
              ...user,
              distance: distanceFromMyUser,
            })
          } else if (gender === 'everyone') {
            tmpUsers.push({
              ...user,
              distance: distanceFromMyUser,
            })
          }
        }

        tmpUsers.sort((a, b) => ((a.distance > b.distance) ? 1 : -1))
      })

      // Filter all users that are NOT within radius of e.g. 20 km
      let shortestDistances = []

      if (distance === 'whole country') {
        // Magic num for whole country
        shortestDistances = tmpUsers.filter((item) => item.distance < 2000)
      } else {
        shortestDistances = tmpUsers.filter((item) => item.distance < parseInt(distance, 10))
      }

      // TODO Remove decimals from distances
      const removeDecimals: Array<ResultAppUser> = []
      shortestDistances.forEach((element) => {
        removeDecimals.push({
          ...element,
          distance: roundNearest10(element.distance),
        })
      })

      resolve(removeDecimals)
    })

    res.json({
      count: newPromise.length,
      results: newPromise,
    })
  },
)

exports.newUserSignup = functions.auth.user().onCreate((user) => {
  admin.firestore().collection('users').doc(user.uid).set({
    id: user.uid,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    setupIsCompleted: false,
    currentGeoLocation: new admin.firestore.GeoPoint(0.0, 0.0),
    name: '',
    bio: '',
    bggName: '',
    currentLocation: '',
    gender: '',
    email: user.email,
    age: 0,
    profilePhotoPaths: [
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    languages: [],
    favBoardGameGenres: [],
    favBgMechanics: [],
    favBgThemes: [],
    favBoardGames:
    {
      familyGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },

        {
          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      dexterityGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      partyGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {

          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      thematicGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {

          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {

          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      strategyGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      abstractGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {

          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
      ],
      warGames: [
        {
          rank: 1,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },
        {
          rank: 2,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },

        },
        {
          rank: 3,
          boardGame: {
            bggId: 0,
            imageUrl: [''],
            name: '',
            recRank: 0,
            recRating: 0.0,
            recStars: 0.0,
            year: 0,
          },
        },

      ],
    },
  }, { merge: true })
})

exports.updatedUser = functions.firestore.document('users/{userId}')
  .onUpdate((change) => {
    // Retrieve the current and previous value
    const data = change.after.data()
    const previousData = change.before.data()

    // We'll only update if the name has changed.
    // This is crucial to prevent infinite loops.
    // TODO add all other fields as well
    if (data.name === previousData.name) {
      return null
    }

    // Return a promise of a set operation to update the count
    return change.after.ref.set({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true })
  })
