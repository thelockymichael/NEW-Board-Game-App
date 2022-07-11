import * as functions from "firebase-functions"
import * as admin from 'firebase-admin'
import cors from 'cors'
import express, { Request, Response } from "express"

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript


const app = express()
// app.use(express.json)
// app.use(express.urlencoded())

admin.initializeApp()

app.use(cors({origin: true}))

app.get("/api/jotain", (req, res) => {

  return res.json({msg: "hello world"})
})

app.get("/api/helloWorld", async (req: Request, res: Response) => {
  const date = new Date()
  const hours = (date.getHours() % 12) + 1  // London is UTC + 1hr;
  return res.json({bongs: 'BONG '.repeat(hours)})
})

// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true})
//   response.send("Hello from Firebase!")
// })

exports.app = functions.https.onRequest(app)