var express = require("express");
var app = express();

const {
    Client
} = require('pg');

const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'app_memo',
    password: 'admin',
    port: 5432,
});

client.connect();
var https = require('https');
var http = require('http');
const fs = require('fs');
const {
    query
} = require("express");
const options = {
    key: fs.readFileSync('key.pem'),
    cert: fs.readFileSync('cert.pem')
}
let memos;

function getAllMemo() {
    const query = `SELECT * FROM memo`;
    client.query(query)
        .then(res => {
            memos = res.rows;
            console.log(res.rows);
            return res.rows;
        })
        .catch(err => {
            console.error(err)
        })
}

function insertNewMemo(title, body, tag) {
    const query = `insert into memo (title, body, tag) VALUES ('${title}','${body}','${tag}');`;
    client.query(query)
        .then(res => {
            memos = res.rows;
            console.log(res.rows);
            return res.rows;
        })
        .catch(err => {
            console.error(err)
        })
}

let port = 2002
app.listen(port);
console.log("Server started at localhost:" + port)

app.get('/', function(req, res) {
    getAllMemo();
    res.send(JSON.stringify(memos));
});

app.post('/api/memo/new', function(req, res) {
    var memoTitle = req.param('title');
    var memoBody = req.param('body');
    var memoTag = req.param('tag');
    console.log("REQUEST PARAMS: title<" + memoTitle + "> Body:<" + memoBody + "> Tag:<" + memoTag + ">");
    try {
        insertNewMemo(memoTitle, memoBody, memoTag);
    } catch (e) {
        console.log(e)
        res.send(e);
    } finally {
        res.send('Inserted Successfully');
        console.log("DONE")
    }
});

app.post('/api/memo/delete', function(req, res) {
    var deleteWhat = req.param('delete');
    console.log("DELETE MEMO PARAM: <" + deleteWhat + ">");
    try {
        if (deleteWhat == 'all') {
            const query = `DELETE FROM memo`;
            client.query(query)
                .then(res => {})
                .catch(err => {
                    console.error(err)
                })
        } else {
            console.log("Delete is not equal to all. It is" + deleteWhat)
        }
    } catch (e) {
        console.log(e)
        res.send(e);
    } finally {
        res.send(deleteWhat + '');
        console.log("Tutti i memo sono stati eliminati")
    }
});