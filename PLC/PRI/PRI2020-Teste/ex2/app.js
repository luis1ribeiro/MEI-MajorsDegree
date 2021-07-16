var createError = require('http-errors');
var express = require('express');
var path = require('path');
var logger = require('morgan');

var indexRouter = require('./routes/index');

var token = undefined;


console.log(">A obter o token...")
axios.post('http://clav-api.di.uminho.pt/v2/users/login', { "username": "daw2020@teste.uminho.pt", "password":"232" })
  .then(dados => {
    token = dados.data.token
    console.log(">Obtido com succeso o token!!")
  })
  .catch(e => {
    console.log('Erro: não consegui obter o token! |' + e + '\n:::::::::::::A terminar o servidor:::::::::::::')
    process.exit()
  })

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', function (req, res, next) {
  if (token) next();
  else res.jsonp("Refaça o seu pedido daqui a uns segundos, a obter token de acesso" )

}, function (req, res, next) {
  req.token = token; next();
}, indexRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;

