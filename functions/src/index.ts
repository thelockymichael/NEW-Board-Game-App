/* eslint-disable import/no-import-module-exports */
import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import cors from 'cors'
import express, { Request, Response } from 'express'
import { AppUser } from './types/AppUser'

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

// app.get('/api/getNearestUsers', async (req: Request, res: Response) => {
// TODO get query, 1. lat, 2. long and 3. distance
// exports.getNearestUsers = functions.https.onRequest(app)

exports.getNearestUsers = functions.https.onRequest(
  async (req: Request, res: Response) => {
    const ignoreId = req.query.ignoreId as string
    const lat = req.query.lat as unknown as number
    const long = req.query.long as unknown as number
    const distance = req.query.distance as unknown as number
    const limit = parseInt(req.query.limit as unknown as string, 10)

    console.log('LOG lat', lat)
    console.log('LOG long', long)
    console.log('LOG distance', distance)
    console.log('LOG limit', limit)

    const usersRef: admin.firestore.Query<admin.firestore.DocumentData> = db
      .collection('users')
      .limit(limit)
      .orderBy('updatedAt', 'desc')

    const users = await usersRef.get()

    const newPromise: Array<{
      user: AppUser,
      distance: number
    }> = await new Promise((resolve, reject) => {
      const tmpUsers:Array<{
        user: AppUser,
        distance: number
      }> = []

      users.docs.forEach((doc) => {
        console.log(doc.id, '=>', doc.data().currentGeoLocation)

        const user = doc.data() as AppUser

        if (ignoreId === user.id) {
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

        console.log('LOG distanceFromMyUser', distanceFromMyUser)
        // tmpUsers.push(distanceFromMyUser)
        tmpUsers.push({

          user,
          distance: distanceFromMyUser,
        })

        tmpUsers.sort((a, b) => ((a.distance > b.distance) ? 1 : -1))
      })

      const newDistance = distance as unknown as number
      // Filter all users that are NOT within radius of e.g. 20 km
      const shortestDistances = tmpUsers.filter((item) => item.distance < newDistance)

      // TODO for each user's currentLocation
      // TODO Display the distance
      resolve(shortestDistances)
    })

    console.log('LOG newPromise results', newPromise.length)

    res.json({
      // count: newPromise.results.length,
      count: newPromise.length,
      results: newPromise,
    })
  },
)

exports.newUserSignup = functions.auth.user().onCreate((user) => {
  console.log('LOG user created', user.email, user.uid)

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

// .user().onCreate((user) => {
//   console.log('LOG user created', user.email, user.uid)

//   admin.firestore().collection('users').doc(user.uid).set({
//     createdAt: admin.firestore.FieldValue.serverTimestamp(),
//   })
// })

// app.get('/api', (req, res) => {
//   const date = new Date()
//   const hours = (date.getHours() % 12) + 1 // London is UTC + 1hr;
//   res.json({ bongs: 'BONG '.repeat(hours) })
// })

// exports.app = functions.https.onRequest(app)
