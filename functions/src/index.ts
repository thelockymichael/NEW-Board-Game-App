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

// app.get('/api/getNearestUsers', async (req: Request, res: Response) => {
// TODO get query, 1. lat, 2. long and 3. distance
// exports.getNearestUsers = functions.https.onRequest(app)

exports.getNearestUsers = functions.https.onRequest(
  async (req: Request, res: Response) => {
    const lat = req.query.lat as unknown as number
    const long = req.query.long as unknown as number
    const gender = req.query.gender as unknown as string
    const minAge = req.query.minAge as unknown as number
    const maxAge = req.query.maxAge as unknown as number
    const distance = req.query.distance as unknown as string
    const limit = parseInt(req.query.limit as unknown as string, 10)

    // TODO More Options
    let bgMechanics = req.query.bgMechanics  as unknown as Array<string>
    let bgThemes = req.query.bgThemes  as unknown as Array<string>
    let languages = req.query.languages  as unknown as Array<string>
    let localities = req.query.localities  as unknown as Array<string>
    // const bgThemes = req.query.bgThemes as unknown as Array<string>
    // const languages = req.query.languages as unknown as Array<string>
    // const localities = req.query.localities as unknown as Array<string>

    // TODO If any of them even exist

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
    // TODO UserQuery
    // TODO gender MUST ALWAYS BE INCLUDED
    // TODO age MUST ALWAYS BE INCLUDED
    // TODO distance MUST ALWAYS BE INCLUDED
    // TODO mechanics
    // TODO themes
    // TODO locality
    // TODO languages

    const usersRef: admin.firestore.Query<admin.firestore.DocumentData> = db
      .collection('users')
      .limit(limit)
      .orderBy('updatedAt', 'desc')

    // TODO prioritize DISTANCE

    const users = await usersRef.get()

    const newPromise: Array<ResultAppUser> = await new Promise((resolve, reject) => {
      const tmpUsers:Array<ResultAppUser> = []

      users.docs.forEach((doc) => {
        const user = doc.data() as ResultAppUser

        // if (ignoreId === user.id) {
        //   return
        // }
        // IF ignoreId exists
        const ignoreIdExists = ignoreIds.some((ignoreId) => user.id === ignoreId)
        if (ignoreIdExists) {
          return
        }
        // tmpUsers.push(doc.data().currentGeoLocation.longitude)
        // 1. My user
        const myUserLat: number = lat as unknown as number
        const myUserLong: number = long as unknown as number
        // 2. Other user
        const otherLat = user.currentGeoLocation.latitude
        const otherLong = user.currentGeoLocation.longitude

        // TODO req: contains user's geo location and distance in km
        // TODO IGNORE SWIPE IDs

        // TODO push all user's that are within the radius of e.g. 50 km
        // TODO GET all users by updatedAt

        const distanceFromMyUser = getDistanceFromLatLonInKm(
          myUserLat,
          myUserLong,
          otherLat,
          otherLong,
        )

        // TODO gender MUST ALWAYS BE INCLUDED
        // TODO age MUST ALWAYS BE INCLUDED
        // TODO distance MUST ALWAYS BE INCLUDED

        // TODO gender
        // If query gender equals to user gender
        // => then add user to tmpUsers

        // TODO minAge

        // TODO maxAge
        const date = new Date(0)
        date.setMilliseconds(user.age)

        const userAge = new Date().getFullYear() - date.getFullYear()

        // Check if user's age is in range.
        if (userAge >= minAge && userAge <= maxAge) {
          // Check if user's gender is in range

          // TODO Mechanic
          // TODO Theme
          // TODO Languages
          // TODO Locality
          // If array includes any

          // const newBgMechanics = []
          let containsMechanics = false
          let containsThemes = false
          let containsLanguages = false
          let containsLocalities = false

          if (bgMechanics) {
            console.log('LOG bgMechanic IS NOT EMPTY')
            console.log('LOG bgMechanic IS NOT EMPTY', bgMechanics)
            containsMechanics = findCommonElements(user.favBgMechanics, bgMechanics)
          } else {
            console.log('LOG bgMechanic IS EMPTY')
            console.log('LOG bgMechanic IS EMPTY', bgMechanics)
          }

          if (bgThemes) {
            console.log('LOG bgThemes IS NOT EMPTY')
            console.log('LOG bgThemes IS NOT EMPTY', bgThemes)
            containsThemes = findCommonElements(user.favBgThemes, bgThemes)
          } else {
            console.log('LOG bgThemes IS EMPTY')
            console.log('LOG bgThemes IS EMPTY', bgThemes)
          }

          if (languages) {
            console.log('LOG languages IS NOT EMPTY')
            console.log('LOG languages IS NOT EMPTY', languages)
            containsLanguages = findCommonElements(user.languages, languages)
          } else {
            console.log('LOG languages IS EMPTY')
            console.log('LOG languages IS EMPTY', languages)
          }

          if (localities) {
            console.log('LOG localities IS NOT EMPTY')
            console.log('LOG localities IS NOT EMPTY', localities)
            containsLocalities = findCommonElements([user.currentLocation], localities)
          } else {
            console.log('LOG localities IS EMPTY')
            console.log('LOG localities IS EMPTY', localities)
          }

          // TODO Another if-else statements

          if (bgMechanics || bgThemes || languages || localities) {
            console.log('LOG  TODO Another if-else statements bgThemes IS NOT EMPTY')
            console.log('LOG  TODO Another if-else statements bgThemes IS NOT EMPTY', bgThemes)

            console.log('LOG  TODO Another if-else statements bgThemes IS NOT EMPTY')
            console.log('LOG  TODO Another if-else statements bgThemes IS NOT EMPTY', bgThemes)

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

        // const containsMechanics = findCommonElements(user.favBgMechanics, bgMechanics)

        // bgMechanics

        // const containsThemes = findCommonElements(user.favBgThemes, bgThemes)
        // const containsLanguages = findCommonElements(user.languages, languages)
        // const containsLocalities = findCommonElements([
        //   user.currentLocation.toLowerCase()], localities)

        // if (containsMechanics) {

        // }

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

      // TODO for each user's currentLocation
      // TODO Display the distance
      resolve(removeDecimals)
    })

    res.json({
      // count: newPromise.results.length,
      count: newPromise.length,
      results: newPromise,
    })
  },
)

exports.newUserSignup = functions.auth.user().onCreate((user) => {
  admin.firestore().collection('users').doc(user.uid).set({
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
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
