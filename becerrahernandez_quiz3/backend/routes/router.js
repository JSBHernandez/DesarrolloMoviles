import { Router } from 'express';
const router = Router();
import { login, saveLogin, validateToken, validate } from '../controllers/authController.js';
import { getItems  } from '../controllers/itemsController.js';

router.post('/login', (req, res) => {
    const { email, password } = req.body;
    if (email === 'test@example.com' && password === '123456') {
        res.status(200).json({ token: 'fake-jwt-token' });
    } else {
        res.status(401).json({ message: 'Usuario o contraseña inválidos' });
    }
});
router.post('/validateToken', validateToken, validate);
router.post('/loginWithBiometric', validateToken, login);
router.post('/saveBiometric', validateToken, saveLogin);
router.post('/getItems', validateToken, getItems);

export default router;