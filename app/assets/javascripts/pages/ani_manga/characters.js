$('.slide > .characters').live('ajax:success cache:success', function(e) {
  if (e.type == 'cache:success' && 'mutex' in arguments.callee) {
    return;
  }
  arguments.callee.mutex = true;

});
