import express from 'express';
import router from './routes/router.js';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.use('/public', express.static(path.join(__dirname, 'public')));
app.use('/', router);

app.listen(3000, () => {
    console.log('Bienvenido al servidor, puerto 3000');
});