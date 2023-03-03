import query from "./query.js";
import * as ramda from 'ramda';

export async function batchAuthors(ids) {
    const sql = `SELECT * FROM authors WHERE id IN (?)`;
    const params = [ids];
    return await query(sql, params);
}

export async function batchBooks(authorIds) {
    const sql = `SELECT * FROM books WHERE author IN (?)`;
    const params = [authorIds];
    const books = await query(sql, params);
    const grouped = ramda.groupBy(book => book.author , books);
    return ramda.map(id => grouped[id] || [], authorIds);
}

export async function batchPublishers(publisherIds) {
    const sql = `SELECT * FROM publishers WHERE id IN (?)`;
    const params = [publisherIds];
    return await query(sql, params);
}
