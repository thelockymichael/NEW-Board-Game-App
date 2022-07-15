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
    let ignoreIds = req.query.ignoreId as unknown as Array<string>

    if (!Array.isArray(ignoreIds)) {
      ignoreIds = [ignoreIds]
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
