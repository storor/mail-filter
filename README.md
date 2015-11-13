## Problem Statement
Task is to write a Node.js module exporting one single function:

`filter(messages, rules)`

- *messages* is a mapping of unique message IDs to objects with two string properties: from and to. Each object describes one e-mail message.
- *rules* is an array of objects with three string properties: from (optional), to (optional), and action (mandatory). Each object describes one mail filtering rule.

All strings in the input are non-empty and only contain ASCII characters between 0x20 (space) and 0x7F (del) (inclusive).

A rule is said to match a message if its from and to properties simultaneously match the corresponding properties of the message. The matching is case-sensitive, with \* in the rule matching any number (zero or more) of arbitrary characters, and ? matching exactly one arbitrary character. If from or to are omitted, they are assumed to have the default value \*. As a consequence, a rule that has neither from nor to, matches all messages.

Every message must have all matching rules applied to it, in the order in which the rules are listed. The filter function returns a mapping of message IDs to arrays of actions. For each message, the array should contain the values of the action property from all rules that match this message, respecting the order of the rules. If no rules match a certain message, its corresponding array in the output must still exist (and be empty).

Example
Here is an example of a typical valid call to the filter function:

```filter({
    msg1: {from: 'jack@example.com', to: 'jill@example.org'},
    msg2: {from: 'noreply@spam.com', to: 'jill@example.org'},
    msg3: {from: 'boss@work.com', to: 'jack@example.com'}
}, [
    {from: '*@work.com', action: 'tag work'},
    {from: '*@spam.com', action: 'tag spam'},
    {from: 'jack@example.com', to: 'jill@example.org', action: 'folder jack'},
    {to: 'jill@example.org', action: 'forward to jill@elsewhere.com'}
])```

This is what a correct implementation of filter would return in the above case:

```{
    msg1: ['folder jack', 'forward to jill@elsewhere.com'],
    msg2: ['tag spam', 'forward to jill@elsewhere.com'],
    msg3: ['tag work']
}```
