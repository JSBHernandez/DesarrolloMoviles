const express = require('express');
const { Favorite, Article, User } = require('../models');
const router = express.Router();

router.get('/', async (req, res) => {
  const favorites = await Favorite.findAll({ include: [Article, User] });
  res.json(favorites);
});

router.post('/', async (req, res) => {
  const favorite = await Favorite.create(req.body);
  res.json(favorite);
});

router.delete('/:id', async (req, res) => {
  await Favorite.destroy({ where: { id: req.params.id } });
  res.sendStatus(204);
});

module.exports = router;