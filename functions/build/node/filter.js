/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable no-undef */
// /// npm install --save bad-words
// import Filter from "bad-words"

// export const getCleanedMessage = function(message, doneCallback) {
//   const filter = new Filter()
//   if (filter.isProfane(message)) {
//     const cleanedMessage = filter.clean(message)
//     doneCallback(cleanedMessage)
//   } else {
//     doneCallback(message)
//   }
// }

/// npm install --save bad-words
const Filter = require('bad-words')

exports.getCleanedMessage = function(message, doneCallback) {
  const filter = new Filter()
  if (filter.isProfane(message)) {
    const cleanedMessage = filter.clean(message)
    doneCallback(cleanedMessage)
  } else {
    doneCallback(message)
  }
}