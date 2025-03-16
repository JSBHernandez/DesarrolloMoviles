const { Sequelize } = require('sequelize');
const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: 'database.sqlite'
});

const User = require('./user')(sequelize);
const Article = require('./article')(sequelize);
const Favorite = require('./favorite')(sequelize);

User.hasMany(Favorite);
Favorite.belongsTo(User);
Article.hasMany(Favorite);
Favorite.belongsTo(Article);

sequelize.sync();

module.exports = { User, Article, Favorite, sequelize };