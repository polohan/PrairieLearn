var ERR = require('async-stacktrace');

var sqldb = require('../lib/sqldb');
var sqlLoader = require('../lib/sql-loader');

var sql = sqlLoader.loadSqlEquiv(__filename);

module.exports = function(req, res, next) {
    var params = {
        course_id: res.locals.course.id,
    };
    sqldb.queryOneRow(sql.select_open_error_count, params, function(err, result) {
        if (ERR(err, next)) return;
        res.locals.navbarOpenErrorCount = result.rows[0].count;
        next();
    });
};
