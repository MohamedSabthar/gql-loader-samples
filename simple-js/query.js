import mysql from 'mysql2';

const client = mysql.createPool({
  host: 'localhost',
  user: 'root',
  database: 'mydatabase',
  password: 'password',
});

function logQuery(sql, params) {
  console.log(mysql.format(sql, params));
}

export default async function query(sql, params = null) {
  logQuery(sql, params);
  try {
    const [rows, _]  = await client.promise().query(sql, params);
    return rows;
  } catch (err) {
    console.log(err);
  } 
}