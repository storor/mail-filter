var filter = require('./relsease');

var initialMessages = {
  msg1: {
    from: 'jack@example.com',
    to: 'jill@example.org'
  },
  msg2: {
    from: 'noreply@spam.com',
    to: 'jill@example.org'
  },
  msg3: {
    from: 'boss@work.com',
    to: 'jack@example.com'
  }
};
initialRules = [
  {
    from: '*@work.com',
    action: 'tag work'
  }, {
    from: '*@spam.com',
    action: 'tag spam'
  }, {
    from: 'jack@example.com',
    to: 'jill@example.org',
    action: 'folder jack'
  }, {
    to: 'jill@example.org',
    action: 'forward to jill@elsewhere.com'
  }
];

console.log(filter(initialMessages, initialRules));
