import { Router } from 'express';
const router = Router();
import { login, saveLogin, validateToken, validate } from '../controllers/authController.js';
import { getItems  } from '../controllers/itemsController.js';

router.post('/login', login);
router.post('/validateToken', validateToken, validate);
router.post('/loginWithBiometric', validateToken, login);
router.post('/saveBiometric', validateToken, saveLogin);
router.post('/getItems', validateToken, getItems);

export default router;