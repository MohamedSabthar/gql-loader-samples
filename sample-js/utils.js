import query from "./query.js";

export async function getAuthors(ids) {
    const sql = `SELECT * FROM authors WHERE id IN (?)`;
    const params = [ids];
    return await query(sql, params);
}

export async function getBooks(authorId) {
    const sql = `SELECT * FROM books WHERE author = ?`;
    const params = [authorId];
    return await query(sql, params);
}

export async function getAuthor(authorId) {
    const sql = `SELECT * FROM authors WHERE id = ?`;
    const params = [authorId];
    var rows = await query(sql, params);
    return rows[0];
}

export async function getPublisher(publisherId) {
    const sql = `SELECT * FROM publishers WHERE id = ?`;
    const params = [publisherId];
    var rows = await query(sql, params);
    return rows[0];
}
