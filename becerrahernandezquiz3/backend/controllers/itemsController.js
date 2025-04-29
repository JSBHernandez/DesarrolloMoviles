import pool from '../database/db.js';

async function getItems(req, res) {
    try {
        const query = 'SELECT * FROM articulos';
        const [rows] = await pool.promise().query(query);

        rows.forEach(row => {
            row.urlimagen = process.env.APP_HOST + row.urlimagen;
        });

        if (rows.length === 0) {
            return res.status(204).json({
                message: 'No se encontraron items'
            });
        } else {
            res.status(200).json(rows);
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            message: 'Server error'
        });
    }
}

export { getItems };
