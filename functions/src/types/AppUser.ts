export type NewPhotographer = Omit<AppUser, 'id'>

interface AppUser {
  email: string,
  age: number,
  gender: string,
}

interface IMessage {
  text: string,
}

export type { AppUser, IMessage }
