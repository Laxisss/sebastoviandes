const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const multer = require('multer');
const app = express();
app.use(express.json());
app.use(cors());
app.use('/images', express.static('images'));
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'images/')
  },
  filename: function (req, file, cb) {
    console.log(file)
    cb(null, Date.now() + '.JPG')
  }
})
let upload = multer({
  dest: "./images",
  storage: storage
});
const port = 3000;
var d = new Date();
var hours = d.getHours();
var minutes = d.getMinutes();
var seconds = d.getSeconds();
const host = "localhost";
const user = "root";
const password = "";
const database = "sebastoviandes";
// var path = require('path');
// var imgs = path.join(__dirname, 'images/');
// console.log(imgs);
// console.log(__dirname);
// const fs = require("fs");

app.post('/_products', upload.fields([]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      var query = "SELECT produits.ID_Produit, produits.Libelle, produits.Prix, produits.Unite, produits.Lien_Photo, IFNULL(affichageuser.UniteUser, RIGHT(produits.Unite,1)) AS UniteComm, IFNULL(affichageuser.Grammage, 0) as Grammage, typeproduits.Libelle AS TypeProduit, typeproduits.ID_TypeProduit";
      query += " FROM produits";
      query += " LEFT JOIN affichageuser ON affichageuser.ID_AffichageUser = produits.ID_AffichageUser"
      query += " LEFT JOIN typeproduits ON typeproduits.ID_TypeProduit = produits.typeproduit";
      if(req.body.prixMin != null || req.body.prixMax != null || req.body.typeProduit != null) {
        query += " WHERE";
        if(req.body.prixMin != null || req.body.prixMax != null) {
          query += "(produits.prix BETWEEN " + req.body.prixMin + " AND " + req.body.prixMax + ")";
          if(req.body.typeProduit != null) {
            query += " AND";
          }
        }
        if(req.body.typeProduit != null) {
          query += " typeProduits.ID_TypeProduit = " + req.body.typeProduit
        }
      }
      client.query(query, function(err, rows, fields){
        if(!err){
          for(let row in rows) {
            //console.log(req.protocol + "://" + req.get('host') + "/images/" + rows[row].Lien_Photo);
            rows[row].Lien_Photo = req.protocol + "://" + req.get('host') + "/images/" + rows[row].Lien_Photo;
          }
          res.send(JSON.stringify(rows))
        }
        else{
          console.log(query, "\n")
          console.log("Le SELECT n'as pas marché. "+err);
        }
        client.end();
      });
    }
    else{
      console.log("Connexion échouée!\n Erreur : "+ JSON.stringify(err));
    }
  });
});

app.post('/_addProducts', upload.fields([{ name: "image", maxCount: 1 }]), (req,res)=>{
  const imageName = req.files['image'][0].filename;
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });

  function classicBody(type){
    let query = 'CALL insertProduit(?,?,?,?,?,?,?);';
    const params = [
      req.body.lib,
      imageName,
      req.body.prix,
      req.body.unit,
      type,
      req.body.unitComm,
      req.body.grammage
    ]
    client.query(query, params, function(err, rows, fields){
      if(!err){
        res.send('true');
      }
      else {
        console.log(query, "\n")
        console.log("La fonction n'a pas marché "+ err);
      }
      client.end();
    })
  }

  client.connect((err) => {
    if(!err){
      let type = req.body.type
      if(isNaN(type)){
        let query = "INSERT INTO `typeproduits`(`Libelle`) VALUES ('"+type+"');";
        client.query(query, function(err, rows, fields){
          if(!err){
            query = "SELECT `ID_TypeProduit` FROM `typeproduits` WHERE Libelle = '"+type+"'";
            client.query(query, function(err, rows, fields){
              if(!err){
                type = rows[0].ID_TypeProduit;
                classicBody(type);
              }
              else {
                console.log(query, "\n")
                console.log("Le SELECT n'as pas marché. "+err);
              }
            });
          }
          else { 
            console.log(query, "\n")
            console.log("Le INSERT n'as pas marché. "+err);
          }
        });
      }
      else {
        classicBody(req.body.type);
      }
    }
    else{
      console.log("Connexion échouée!\n Erreur : "+ JSON.stringify(err));
    }
  })
});

app.post('/_updateProducts', upload.fields([{ name: "image", maxCount: 1 }]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let params = [
        req.body.lib,
        req.body.prix,
        req.body.unit,
        req.body.type
      ]
      let query = "UPDATE `produits` SET `Libelle`= ?,`Prix`= ?,`Unite`= ?,`typeproduit`= ?";
      if(req.files?.['image']?.[0]) {
        console.log('good');
        query += ",`Lien_Photo`= ?";
        params.push(req.files['image'][0].filename)
      }
      else {
        console.log('bad');
      }
      query += " WHERE `ID_Produit` = ?;";
      params.push(req.body.id);
      client.query(query, params, (err, rows, fields) => {
        if(!err) {
          res.send('true')
        }
        else {
          console.log(query, "\n");
          res.send('false');
          console.log("Le UPDATE n'as pas marché. "+err);
        }
      })
    }
    else{
      console.log("Connexion échouée!\n Erreur : "+ JSON.stringify(err));
    }
  })
});

app.get('/:id/_echellons',(req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      var query = "SELECT echellons.Libelle, echellons.Valeur FROM echellons";
      query += " INNER JOIN produits ON echellons.ID_Produit = produits.ID_Produit";
      query += " WHERE produits.ID_Produit = "+ req.params.id +" ORDER BY echellons.Valeur, echellons.Libelle LIMIT 3;";
      client.query(query, function(err, rows, fields){
        if(!err){
          res.send(JSON.stringify(rows))
        }
        else{
          console.log(query, "\n")
          console.log("Le SELECT n'as pas marché. "+err);
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
    }
  });
});

app.post('/_connect', upload.fields([]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      var query = "SELECT verifyUser('"+req.body.username+"','"+req.body.password+"') AS nbComptes";
      client.query(query, function(err, rows, fields){
        if(!err){
          if(rows[0].nbComptes == 1) {
            query = "SELECT `ID_Utilisateur`, `Nom`, `Prenom`, `NumTel`, `Email`, `isAdmin` FROM `utilisateurs` WHERE (utilisateurs.NumTel = '"+req.body.username+"' OR utilisateurs.Email = '"+req.body.username+"') AND utilisateurs.MotDePasse = SHA('"+req.body.password+"');";
            client.query(query, function(err, rows, fields){
              if(!err){
                if(rows != null){
                  if(rows[0] != null){
                    res.send(JSON.stringify(rows[0]));
                  }
                  else {
                    res.send('false');
                  }
                }
                else {
                  res.send('false');
                }
              }
              else {
                console.log(query, "\n")
                console.log("Le SELECT n'as pas marché. "+err);
                res.send("false");
              }
              client.end();
            });
          }
          else {
            res.send("false");
          }
        }
        else{
          console.log(query, "\n")
          console.log("Le SELECT n'as pas marché. "+err);
          res.send('false');
        }
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
    // client.end();
  });
});

app.get('/:id/_getAdmin', (req, res) => {
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err) {
      let query = "SELECT isAdmin FROM utilisateurs WHERE ID_Utilisateur = ?;";
      client.query(query, [req.params.id], (err, rows, fields) => {
        if(!err) {
          res.json(rows);
        }
        else {
          console.log(query, "\n");
          console.log("Le SELECT n'as pas marché. "+err);
          res.send('false');
        }
        client.end();
      });
    }
  });
});

app.get('/:criteria/_getUsers', (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  if(req.params.criteria == 0){
    req.params.criteria = "%";
  }
  client.connect((err) => {
    if(!err){
      var query = "SELECT `ID_Utilisateur`, `Nom`, `Prenom`, `NumTel`, `Email`, `isAdmin` FROM `utilisateurs` WHERE isAdmin = 1 AND (LCASE(utilisateurs.Prenom) LIKE '%"+req.params.criteria.toLowerCase()+"%' OR LCASE(utilisateurs.Nom) LIKE '%"+req.params.criteria.toLowerCase()+"%' OR LCASE(utilisateurs.NumTel) LIKE '%"+req.params.criteria.toLowerCase()+"%' OR LCASE(utilisateurs.Email) LIKE '%"+req.params.criteria.toLowerCase()+"%')";
      client.query(query, function(err, rows, fields){
        if(!err){
          res.send(rows);
        }
        else{
          console.log(query, "\n")
          console.log("Le SELECT n'as pas marché. "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.post('/_createUser', upload.fields([]), (req,res)=>{
  console.log(req.body.admin)
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "SELECT count(*) as nbComptes FROM Utilisateurs WHERE Utilisateurs.Email = '"+req.body.email+"' OR Utilisateurs.NumTel = '"+req.body.phone+"'";
      client.query(query, function(err, rows, fields){
        if(!err) {
          if(rows[0]['nbComptes'] > 0) {
            res.send('false');
          } else {
            let isAdmin = 0;
            if(req.body.admin){
              isAdmin = 1;
            }
            var query = "CALL insertUser('"+req.body.name+"','"+req.body.firstname+"','"+req.body.email+"','"+req.body.phone+"','"+req.body.password+"',"+isAdmin+")";
            client.query(query, function(err, rows, fields){
              if(!err){
                res.send('true');
              }
              else{
                console.log(query, "\n")
                console.log("Le INSERT n'as pas marché. "+err);
                res.send('false');
              }
              client.end();
            });
          }
        }
        else {
          console.log(query, "\n")
          console.log("Le Verify n'as pas marché. "+err);
          res.send('false');
        }
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.post('/_modifMDP', upload.fields([]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "CALL changePasswd("+req.body.userID+",'"+req.body.newMDP+"')";
      client.query(query, function(err, rows, fields){
        if(!err) {
          res.send('true');
        }
        else {
          console.log(query, "\n")
          console.log("Le changepasswd n'as pas marché. "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.get('/:id/_deleteUser', upload.fields([]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "DELETE FROM `utilisateurs` WHERE `utilisateurs`.`ID_Utilisateur` = "+req.params.id;
      client.query(query, function(err, rows, fields){
        if(!err) {
          res.send('true');
        }
        else {
          console.log(query, "\n")
          console.log("Le delete n'as pas marché. "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.get('/_types',(req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "SELECT * from typeProduits";
      client.query(query, function(err, rows, fields){
        if(!err) {
          console.log(rows);
          res.send(rows);
        }
        else {
          console.log(query, "\n")
          console.log("Le Verify n'as pas marché. "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});


app.post('/_addCommande', upload.fields([]),(req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "SELECT IFNULL(MAX(commandes.ID_Commandes),0)+1 AS maxID FROM commandes";
      client.query(query, function(err, rows, fields){
        if(!err) {
          const maxID = rows[0]['maxID'];
          query = "INSERT INTO `commandes`(`ID_Commandes`,`Date_Passee`, `Date_Recup`, `Recuperee`, `ID_Utilisateur`) VALUES ("+maxID+",NOW(),'"+req.body.dateRecup+"',false,"+req.body.userID+")";
          client.query(query, function(err, rows, fields){
            if(!err) {
              let panier = req.body.panier;
              let fullValues = [];
              for(let row in panier) {
                let newRow = panier[row].split(',');
                query = "INSERT INTO `commander`(`ID_Commandes`, `ID_Produit`, `Quantite`) VALUES ?";
                let values = [maxID,Number(newRow[0]),Number(newRow[1])];
                fullValues.push(values);
              }
              client.query(query, [fullValues], function(err, rows, fields){
                if(!err){
                  console.log('bulkinsert successful');
                  res.send('true');
                }
                else {
                  console.log(query, "\n")
                  console.log(fullValues, "\n")
                  console.log("Le bulkInsert n'as pas marché. -> "+err);
                  res.send('false');
                }
                client.end();
              });
            }
            else{
              console.log(query, "\n")
              console.log("Le INSERT n'as pas marché. -> "+err);
              res.send('false');
            }
          });
        }
        else {
          console.log(query, "\n")
          console.log("Le SELECT n'as pas marché. -> "+err);
          res.send('false');
        }
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.post('/_getCommandes', upload.fields([]), (req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "SELECT * FROM getCommandes WHERE Date_Recup = '"+req.body.date+"' ORDER BY date_passee, ID_Commandes ASC";
      client.query(query, function(err, rows, fields){
        if(!err) {
          console.log(rows);
          res.send(JSON.stringify(rows));
        }
        else {
          console.log(query, "\n")
          console.log("Le UPDATE n'as pas marché. -> "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.get('/:id/_validateCommande',(req,res)=>{
  const client = mysql.createConnection({
    host,
    user,
    password,
    database
  });
  client.connect((err) => {
    if(!err){
      let query = "UPDATE `commandes` SET `Recuperee`= 1 WHERE ID_Commandes = "+req.params.id+";";
      client.query(query, function(err, rows, fields){
        if(!err) {
          console.log('the validation was successful');
          res.send('true')
        }
        else {
          console.log(query, "\n")
          console.log("Le UPDATE n'as pas marché. -> "+err);
          res.send('false');
        }
        client.end();
      });
    }
    else{
      console.log("connexion échouée!\n Erreur : "+ JSON.stringify(err));
      res.send('false');
    }
  });
});

app.listen(port, () => {
    console.log(`${hours}:${minutes}:${seconds} Example app listening at http://localhost:${port}`)
});
