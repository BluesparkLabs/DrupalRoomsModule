(function ($) {

Drupal.behaviors.roomsAvailabilityPrepareForm = {
  attach: function(context) {
    $("form#rooms-filter-month-form select").once('select').change(function() {
      $("form#rooms-filter-month-form").submit();
    });

    $('#edit-select-all').once('select').change(function() {
      var table = $(this).closest('table')[0];
      if (this.options.selectedIndex == 1) {
        $('input[id^="edit-rooms"]:not(:disabled)', table).attr('checked', true);
      }
      else if (this.options.selectedIndex == 2) {
        $('input[id^="edit-rooms"]:not(:disabled)', table).attr('checked', true);
      }
      else if (this.options.selectedIndex == 3) {
        $('input[id^="edit-rooms"]:not(:disabled)', table).attr('checked', false);
      }
    });
  }
};

Drupal.behaviors.roomsPricing = {
  attach: function(context) {

    // Current month is whatever comes through -1 since js counts months starting from 0
    currentMonth = Drupal.settings.roomsUnitManagement.currentMonth - 1;
    currentYear = Drupal.settings.roomsUnitManagement.currentYear;

    // The first month on the calendar
    month1 = currentMonth;
    year1 = currentYear;

    var calendars = [];
    var i = 0;
    for (i=0;i<Drupal.settings.roomsUnitManagement.roomsNumber;i++) {
      calendars[i] = new Array('#calendar' + i, month1, year1);
    }

    events = [];
    var url = Drupal.settings.basePath + '?q=bam/v1/pricing&units=' + Drupal.settings.roomsUnitManagement.roomsId.join() + '&start_date=' + year1 + '-' + (month1+1) + '-01&duration=1M';
    $.ajax({
      url: url,
      success: function(data) {
        events = data['events'];

        $.each(calendars, function(key, value) {
          $(value[0]).fullCalendar('refetchEvents');
        });
      }
    });

    var c = 0;
    $.each(calendars, function(key, value) {
      phpmonth = value[1]+1;

      var unit_id = Drupal.settings.roomsUnitManagement.roomsId[c];

      $(value[0]).once().fullCalendar({
        schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
        contentHeight: 74,
        views: {
          timeline8Week: {
            type: 'timeline',
            slotDuration: { days: 7 },
            duration: { days: 64 }
          }
        },
        defaultView: 'timeline8Week',
        dayNamesShort:[Drupal.t("Sun"), Drupal.t("Mon"), Drupal.t("Tue"), Drupal.t("Wed"), Drupal.t("Thu"), Drupal.t("Fri"), Drupal.t("Sat")],
        monthNames:[Drupal.t("January"), Drupal.t("February"), Drupal.t("March"), Drupal.t("April"), Drupal.t("May"), Drupal.t("June"), Drupal.t("July"), Drupal.t("August"), Drupal.t("September"), Drupal.t("October"), Drupal.t("November"), Drupal.t("December")],
        defaultDate: moment([value[2],value[1]]),
        header:{
          left: '',
          center: '',
          right: ''
        }
      });

      c++;
    });

    // Resize takes care of some quirks on occasion
    $(window).resize();

  }
};
})(jQuery);
