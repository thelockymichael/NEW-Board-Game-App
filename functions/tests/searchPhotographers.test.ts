import * as index from "../src"
import * as admin from 'firebase-admin'
import functions from "firebase-functions-test"
import { photographers } from "../src/dummy-data/photographers"

jest.setTimeout(10000)

// STEP 1.
// * Change item ids to uuid4
// STEP 2.
// * beforeAll
// - create these items in Firestore []
// STEP 3.
// * afterAll
// - delete all items in Firestore []

// test cases
// expect to find one photographer from Lappeenranta

// expect to find two photographers that charge 50€ / hour


const testEnv = functions({
  databaseURL: "https://valokuvaus-vili.firebaseio.com",
  storageBucket: "valokuvaus-vili.appspot.com",
  projectId: "valokuvaus-vili"
}, './service-account.json')


let adminStub: jest.SpyInstance<admin.app.App, [options?: admin.AppOptions, name?: string]>
describe("testing basic function", () => {

  beforeAll(() => {
    adminStub = jest.spyOn(admin, "initializeApp")
    
    photographers.forEach((async (item) => {
      const path = `photographers/${item.id}`

      await admin.firestore().doc(path).set(item)
    }))


  })

  
  test("expect to find two photographers starting with `mic`", done => {
    // A fake request object
    const req = {
      headers: {
        origin: true,
      },
      query: { keyword: "mic" }
    }

    const res = {
      setHeader: (key: any, value: any) => {
      },
      getHeader: (value: any) => {
      },
      json: (value: any) => {
        expect(value.length).toBe(2)
        done()
      },
      status: (code: any) => {
        expect(code).toBe(200)
        done()
      },
      send: (value: any) => {
        
      }
    }
    
    index.searchPhotographers(req as any, res as any)
  })
// expect to find one photographer from Lappeenranta

  test("expect to find one photographer from Lappeenranta", done => {
    // A fake request object
    const req = {
      headers: {
        origin: true,
      },
      query: { keyword: "lap" }
    }

    const res = {
      setHeader: (key: any, value: any) => {
      },
      getHeader: (value: any) => {
      },
      json: (value: any) => {
        expect(value.length).toBe(1)
        done()
      },
      status: (code: any) => {
        expect(code).toBe(200)
        done()
      },
      send: (value: any) => {
        
      }
    }
    
    index.searchPhotographers(req as any, res as any)
  })

  test("expect to find two photographers that charge 50 € / hour", done => {
    // A fake request object
    const req = {
      headers: {
        origin: true,
      },
      query: { keyword: "0,50" }
    }

    const res = {
      setHeader: (key: any, value: any) => {
      },
      getHeader: (value: any) => {
      },
      json: (value: any) => {
        expect(value.length).toBe(2)
        done()
      },
      status: (code: any) => {
        expect(code).toBe(200)
        done()
      },
      send: (value: any) => {
        
      }
    }
    
    index.searchPhotographers(req as any, res as any)
  })

  afterAll(() => {
    adminStub.mockRestore()
    testEnv.cleanup()
  })
})
