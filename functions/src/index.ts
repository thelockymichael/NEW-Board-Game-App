/* eslint-disable import/no-import-module-exports */
import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import cors from 'cors'
import express, { Request, Response } from 'express'
// import firebase from 'firebase/app'
// import { IMessage } from './types/AppUser'

// const db = firebase.firestore()

const app = express()
app.use(express.json())
app.use(express.urlencoded())

admin.initializeApp()

// CORS configuration.
// const options: cors.CorsOptions = {
//   origin: true,
// }

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

app.get('/api/getNearestUsers', async (req: Request, res: Response) => {
  // TODO get query, 1. lat, 2. long and 3. distance

  const {
    lat, long, distance, ignoreId,
  } = req.query

  console.log('LOG lat', lat)
  console.log('LOG long', long)
  console.log('LOG distance', distance)

  // TODO req: contains user's geo location and distance in km
  // TODO IGNORE SWIPE IDs

  // TODO push all user's that are within the radius of e.g. 50 km

  const usersRef: admin.firestore.Query<admin.firestore.DocumentData> = db.collection('users')

  const users = await usersRef.get()

  // messages.docs.forEach(async (doc) => {
  const newPromise = await new Promise((resolve, reject) => {
    const tmpUsers: Array<any> = []

    users.docs.forEach((doc) => {
      console.log(doc.id, '=>', doc.data().currentGeoLocation)

      if (ignoreId === doc.data().id) {
        return
      }
      // tmpUsers.push(doc.data().currentGeoLocation.longitude)
      // 1. My user
      const myUserLat: number = lat as unknown as number
      const myUserLong: number = long as unknown as number
      // 2. Other user
      const otherLat = doc.data().currentGeoLocation.latitude
      const otherLong = doc.data().currentGeoLocation.longitude

      const distanceFromMyUser = getDistanceFromLatLonInKm(
        myUserLat,
        myUserLong,
        otherLat,
        otherLong,
      )

      console.log('LOG distanceFromMyUser', distanceFromMyUser)
      // tmpUsers.push(distanceFromMyUser)
      tmpUsers.push({ user: doc.data(), distance: distanceFromMyUser })

      tmpUsers.sort((a, b) => ((a.distance > b.distance) ? 1 : -1))
    })

    const newDistance = distance as unknown as number
    // Filter all users that are NOT within radius of e.g. 20 km
    const shortestDistances = tmpUsers.filter((item) => item.distance < newDistance)

    // TODO for each user's currentLocation
    // TODO Display the distance
    resolve(shortestDistances)
  })

  res.json({
    results: newPromise,
  })
})

app.get('/api', (req, res) => {
  const date = new Date()
  const hours = (date.getHours() % 12) + 1 // London is UTC + 1hr;
  res.json({ bongs: 'BONG '.repeat(hours) })
})

exports.app = functions.https.onRequest(app)
