## 0.0.1
Initial release technically works, but runs out of memory on larger lists. Will need to refactor to prevent this.
## 0.0.2
- Refactored to use a SetQueue instead of a Queue, helping with the memory problem. This also sped up crossword generation by making sure that we didn't follow the same path multiple times.
- Refactored the hashCodeFromValuesOnly function to be a relativeHashCode function instead. It now takes into account the relative position of the values, not just the raw values. This make it work as intended with isRelativelyEquivalent/sets.
- Fixed a bug with the placeWord function where words could be placed over each other.
