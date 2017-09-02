/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const utils = require('../lib/utils');
const log = require('loglevel');
log.setDefaultLevel('trace');

describe('utils', () =>
  describe('packageDir', () =>
    it('should be defined', function() {
      const packageDir = utils.packageDir();
      log.trace(`packageDir: ${packageDir}`);
      return expect(packageDir).toBeDefined();
    })
  )
);
