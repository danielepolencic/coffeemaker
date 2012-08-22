// execute function when the page is ready
$(document).ready(function() {
  // put all your jQuery goodness in here.
  if( $('#day').size() ) {
    var hour = moment().hours();
    var minute = moment().minutes();
    $('#day').find('option').eq(0).prop('selected', 'true'); //today is selected
    $('#hour').find('option').eq( hour ).prop('selected', 'true') //hour is selected
    $('#minute').find('option').eq( minute ).prop('selected', 'true') //minute is selected
  }

  $('#settimer').click(function(){
    var day = parseInt( $('#day').val(), 10 );
    var hour = parseInt( $('#hour').val(), 10 );
    var minute = parseInt( $('#minute').val(), 10 );
    // console.log('log day, hour, minute: %o', day, hour, minute);
    var setDate = moment().hours( hour ).minutes( minute ).seconds( 0 ).add( 'd', day );
    console.log('log setDate: %o', setDate);
    var seconds = setDate.unix() - moment().unix();
    if ( seconds < 0 ){
      alert('Hey, I cannot set a date in the past!');
      return;
    }
    $.ajax({
      url     : '/timer/' + seconds,
      type    : 'POST',
      success : function() {
        alert('Yeah, coffee scheduled');
        window.location.href = '/'
      }
    });
  });
});
