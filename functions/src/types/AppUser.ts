// interface AppUserPromise {
//   results:
// }

interface AppUser {
  id: string,
  setupIsCompleted: boolean,
  email: string,
  age: number,
  gender: string,
  bggName: string,
  currentLocation: string,
  currentGeoLocation: CurrentGeoLocation
  profilePhotoPaths: Array<string>
  bio: string,
  languages: Array<string>,
  favBoardGameGenres: Array<string>,
  favBgMechanics: Array<string>,
  favBgThemes: Array<string>,
  favBoardGames: FavBoardGames,
}

interface CurrentGeoLocation {
  latitude: number,
  longitude: number
}

interface FavBoardGames {
 familyGames: Array<SelectedBoardGame>,
 dexterityGames: Array<SelectedBoardGame>,
 partyGames: Array<SelectedBoardGame>,
 thematicGames: Array<SelectedBoardGame>,
 strategyGames: Array<SelectedBoardGame>,
 abstractGames: Array<SelectedBoardGame>,
 warGames: Array<SelectedBoardGame>,
}

interface SelectedBoardGame {
  rank: number,
  boardGame: BoardGameData
}

interface BoardGameData {
  bggId: number,
  imageUrl: Array<string>,
  year: number,
  recRank: number,
  recRating: number,
  recStars: number,
  name: string,
}

export type { AppUser, CurrentGeoLocation }
