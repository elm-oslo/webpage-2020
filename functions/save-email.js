"use strict";

if (process.env.NODE_ENV !== "production") {
  require("dotenv").config();
}

const Sheet = require("google-spreadsheet");

function replaceAll(str, search, replacement) {
  return str.split(search).join(replacement);
}

const privateKey = process.env.SHEETS_PRIVATE_KEY;
const privateKeyId = process.env.SHEETS_PRIVATE_KEY_ID;
const clientEmail = process.env.SHEETS_CLIENT_EMAIL;
const clientId = process.env.SHEETS_CLIENT_ID;
const certUrl = process.env.SHEETS_CERT_URL;
const projectId = process.env.SHEETS_PROJECT_ID;
const spreadsheetId = process.env.SPREADSHEET_ID;

const creds = {
  type: "service_account",
  project_id: projectId,
  private_key_id: privateKeyId,
  private_key: replaceAll(privateKey, "\\n", "\n"),
  client_email: clientEmail,
  client_id: clientId,
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
  client_x509_cert_url: certUrl
};

const doc = new Sheet(spreadsheetId);

exports.handler = function(event, context, callback) {
  if (event.httpMethod === "POST") {
    saveEmail(JSON.parse(event.body).email, callback);
  }
};

function saveEmail(email, callback) {
  doc.useServiceAccountAuth(creds, function(err) {
    if (err) {
      console.log(err);
    }

    doc.addRow(1, { email: email }, function(err, response) {
      if (err) {
        console.log(err);
      }
      if (response.email === email) {
        callback(err, {
          statusCode: 200,
          body: "{}",
          headers: {
            "content-type": "application/json"
          }
        });
      }
    });
  });
}
