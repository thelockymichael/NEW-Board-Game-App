interface UserQuery {
  gender: string,
  minAge: number,
  maxAge: number,
  distance: number,
  bgMechanics: Array<string>,
  bgThemes: Array<string>,
  languages: Array<string>,
  locality: Array<string>,
}

export default UserQuery
