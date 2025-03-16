const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  return sequelize.define('Article', {
    title: {
      type: DataTypes.STRING,
      allowNull: false
    },
    seller: {
      type: DataTypes.STRING,
      allowNull: false
    },
    rating: {
      type: DataTypes.FLOAT,
      allowNull: false
    },
    imageUrl: {
      type: DataTypes.STRING,
      allowNull: false
    }
  });
};