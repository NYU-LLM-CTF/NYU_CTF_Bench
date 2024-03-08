const MemoryStorage = require('simple-memory-storage');

const db = new MemoryStorage();

db.set('dinos', 
[{'name':'Tyrannosaurus Rex', price:500}, 
{'name':'Velociraptor', price: 60}, 
{'name': 'Stegosaurus', price: 200}, 
{'name': 'Triceratops', price: 99}, 
{'name': 'Spinosaurus', price: 100}, 
{'name': 'Ankylosaurus', price: 57},
{'name': 'Brachiosaurus', price: 198},
{'name': 'Dilophosaurus', price: 88}, 
{'name': 'Koasigsessasaurus', price: 88}, 
{'name': 'Carnotaurus', price: 188}]
);

db.set('flagosaurus', {flag: "csawctf{l3ak7_c1!3nt5_0h_m3_0h_my}"})

module.exports = db;

