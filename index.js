var filterObj = require('./filter');

// var filter = new Filter();

global.filter = module.exports = (messages, rules)=>{
  return filterObj.filter(messages, rules);  
}
  
// var messages =  {
//         "msg1": {
//             "from": "jack@example.com",
//             "to": "jill@example.org"
//         },
//         "msg2": {
//             "from": "noreply@spam.com",
//             "to": "jill@example.org"
//         },
//         "msg3": {
//             "from": "boss@work.com",
//             "to": "jack@example.com"
//         }
//     }
// 
// var rules =   
//    [
//         {
//             "from": "jac?@example.com",
//             "action": "tag work"
//         }
//     ]
//     
// var result = global.filter(messages, rules);
// console.log(result);
