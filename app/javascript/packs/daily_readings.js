$(document).on('click', '#add-reading', function () {
    add_new_reading();
});

$(document).on('click', '.delete-reading', function () {
    var id = parseInt($(this).attr('id'))
    $("#reading_details_" + id).remove();
    var count = parseInt($('#readings-count').val() - 1);
    set_count(count);
})

function set_count(count) {
    $('input[name="count"]').val(count);
}

function add_new_reading() {
    var count = parseInt($('#readings-count').val());
    if (count > 3) {
        alert("You can add only 4 readings per day!!!");
    }
    else {
        add_new_reading_form();
        set_count(count + 1);
    }
}

function add_new_reading_form() {
    $.ajax({
        url: '/readings/new',
        type: 'GET',
        dataType: 'html',
        success: function (res) {
            $('#new-readings').append(res);
        }
    });
}

$(document).on('click', '#save-readings', function (event) {
    event.preventDefault();
    remove_error_messages();
    submit_form();
});

function remove_error_messages() {
    $('small').empty();
}

function submit_form() {
    var form_data = get_form_data();
    $.ajax({
        type: 'POST',
        url: '/readings/save_daily_readings',
        data: form_data,
        success: function (response) {
            console.log('Readings saved successfully')
        },
        error: function (request, status, error) {
            var errors = request.responseJSON;
            add_error_messages(errors);
        }
    });
}

function add_error_messages(errors) {
    check_daily_limit_error(errors);
    $.each(errors, function (id, reading) {
        $.each(reading, function (key, error) {
            $("#" + key + "_error_" + id).append(error);
        });
    });
}

function check_daily_limit_error(errors) {
    if (errors['daily_limit']) {
        alert("You can add only 4 readings per day!!!");
    }
    delete errors['daily_limit'];
}

function get_form_data() {
    var form_data = {};
    $.each($('#daily-readings').serializeArray(), function (_, kv) {
        form_data[kv.name] = kv.value;
    });
    return form_data;
}