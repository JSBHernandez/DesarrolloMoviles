import jwt from "jsonwebtoken";
import pool from "../database/db.js";

function generateShortAccessToken(user) {
    return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET, { expiresIn: process.env.SHORT_ACCESS_TOKEN_EXPIRATION });
}

function generateLongAccessToken(user) {
    return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET, { expiresIn: process.env.LONG_ACCESS_TOKEN_EXPIRATION });
}

function validateToken(req, res, next) {
    const accessToken = req.headers['authorization'];

    if (!accessToken) return res.sendStatus(401);

    jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.username = user.username;
        req.password = user.password;
        next();
    });
}

async function validate(req, res) {
    res.json({
        message: 'Token válido'
    });
}

async function login(req, res) {
    let username, password;
    if (req.headers['authorization']) {
        const token = req.headers['authorization'];
        try {
            const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
            username = decoded.username;
            password = decoded.password;
        } catch (err) {
            console.log(err);
            return res.status(401).json({
                message: 'Token inválido'
            });
        }
    } else {
        ({ username, password } = req.body);
    }

    try {
        const [rows] = await pool.promise().query("SELECT * FROM users WHERE username = ? AND password = ?", [username, password]);
        const user = rows[0];
        
        if (!user) {
            return res.status(401).json({
                message: 'Usuario o contraseña incorrectos'
            });
        } else {
            
            const accessToken = generateShortAccessToken(user);
            res.header('authorization', accessToken).json({
                message: 'Usuario autenticado',
                token: accessToken
            });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            message: 'Error en el servidor'
        });
    }
}

async function saveLogin(req, res) {
    const { username, password } = req.body;
    const { username: usernameToken, password: passwordToken } = req;

    try {
        if (username !== usernameToken || password !== passwordToken) {
            return res.status(401).json({
                message: 'Credenciales inválidas'
            });
        }
        const [rows] = await pool.promise().query("SELECT * FROM users WHERE username = ? AND password = ?", [username, password]);
        const user = rows[0];
        if (!user) {
            return res.status(401).json({
                message: 'Usuario o contraseña incorrectos'
            });
        } else {
            const accessToken = generateLongAccessToken(user);
            res.header('authorization', accessToken).json({
                message: 'Usuario autenticado',
                token: accessToken
            });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            message: 'Error en el servidor'
        });
    }
}

export { login, saveLogin, validateToken, validate };