
$(document).ready(function() {
	$('#WindowsBuilds').removeClass('active');
	$('#MacOSXBuilds').removeClass('active');

	var f = function (e) {
	    e.preventDefault()
	    $(this).tab('show')
	};
	$('a[href="#LinuxBuilds"]').hover(f);
	$('a[href="#WindowsBuilds"]').hover(f);
	$('a[href="#MacOSXBuilds"]').hover(f);

	$("#get-sources").height($("#get-packages").height());
	$("#get-packages").height($("#get-packages").height());
    });
