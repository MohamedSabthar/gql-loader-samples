import query from "./query.js";

export async function getAuthors() {
  const sql = `SELECT * FROM authors`;
  return await query(sql);
}

export async function getBooks(authorId) {
  const sql = `SELECT * FROM books WHERE author = ?`;
  const params = [authorId];
  return await query(sql, params);
}

