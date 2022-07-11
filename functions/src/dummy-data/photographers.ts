/* eslint-disable import/prefer-default-export */
import { IPhotographer } from '../types'
// import { v4 as uuidv4 } from 'uuid';
// const path = `photographers/1`

export const photographers: Array<IPhotographer> = [
  {
    id: '310e1bc4-ecbf-4ec9-9209-b05b10b92b78',
    profileImgUrl: 'https://firebasestorage.googleapis.com/v0/b/valokuvaus-vili.appspot.com/o/example_04_1080P.jpg?alt=media&token=bfc4f18b-fa39-4ab5-9b49-bc03e051616d',
    speciality: [
      'parties',
      'nature',
    ],
    phoneNum: '0231412',
    description: 'I like cameras',
    firstName: 'micke',
    lastName: 'sickson',
    pricePerHour: 50,
    addressData: {
      city: 'tampere',
      country: 'finland',
      municipality: 'pirkanmaa',
      streetAddress: 'tarhatie 12',
    },
  },
  {
    id: 'b8057356-9cd0-4488-8852-38b8d571e31c',
    profileImgUrl: 'https://firebasestorage.googleapis.com/v0/b/valokuvaus-vili.appspot.com/o/example_01_1080P.jpg?alt=media&token=a2e39977-c533-4504-947a-937bd282b42c',
    speciality: [
      'weddings',
      'school',
      'parties',
    ],
    phoneNum: '0485354534',
    description: 'I like to take photos',
    firstName: 'matti',
    lastName: 'meikalainen',
    pricePerHour: 50,
    addressData: {
      city: 'kajaani',
      country: 'finland',
      municipality: 'kainuu',
      streetAddress: 'pihlajankuja 12B',
    },
  },
  {
    id: '601fa6d5-ddcc-48eb-a5b5-b5b7cab64b53',
    profileImgUrl: 'https://firebasestorage.googleapis.com/v0/b/valokuvaus-vili.appspot.com/o/example_02_1080P.jpg?alt=media&token=25c4027e-8b0e-4876-9048-82cc9a5c4bba',
    speciality: ['birthdays'],
    phoneNum: '094142129',
    description: 'Professional photographer',
    firstName: 'dick',
    lastName: 'taalasmaa',
    pricePerHour: 75,
    addressData: {
      city: 'espoo',
      country: 'finland',
      municipality: 'uusimaa',
      streetAddress: 'jokusentie 12d',
    },
  },
  {
    id: 'b3964aef-36da-4561-9805-a8ff09ed6479',
    profileImgUrl: 'https://firebasestorage.googleapis.com/v0/b/valokuvaus-vili.appspot.com/o/example_03_1080P.jpg?alt=media&token=e3056d73-1835-4046-bdfa-5e0c1f200efb',
    speciality: [
      'disco',
      'amusement parks',
    ],
    phoneNum: '0321312541',
    description: 'Amateur photographer',
    firstName: 'michael',
    lastName: 'jackson',
    pricePerHour: 100,
    addressData: {
      city: 'lappeenranta',
      country: 'finland',
      municipality: 'etelä-karjala',
      streetAddress: 'sepposentie 69B',
    },
  },
]
