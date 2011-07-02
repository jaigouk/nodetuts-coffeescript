Step(
  function readSelf() {
    fs.readFile(__filename, this);
  },
  function capitalize(err, text) {
    if (err) throw err;
    return text.toUpperCase();
  },
  function showIt(err, newText) {
    if (err) throw err;
    console.log(newText);
  }
);