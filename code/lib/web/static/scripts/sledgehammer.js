var shr = shr || {};

$(function () {
    // confirmation dialog upon click on power-off button
    $('#admin li.power a').click(function () {
        var instanceName = $('h2#title').text();
        return confirm('Вы действительно хотите выключить ' + instanceName);
    });

    // confirmation dialog upon click on delete button
    $('ul.actions li.delete-item a').click(function () {
        var targetTitle = $(this).attr('data-target-title');
        return confirm('Вы действительно хотите удалить "' + targetTitle + '"');
    });

    // notify dialog about warnings
    $('#warnings-notify').dialog({
        modal: true,
        resizable: false,
        width: 500,
        height: 150
    });

    // menus
    $('[role=menu-header]').click(function () {
        var menuId = $(this).attr('data-menu-id');
        $('div[role=menu-body][data-menu-id=' + menuId + ']').slideToggle('fast');
        return false;
    });

    $(':not([role=menu-header])').click(function () {
        $('div[role=menu-body]:visible').slideUp('fast');
    });

    // ajax project state refresh
    var refreshState = function () {
        $('span[role=project-state]').each(function () {
            var element = $(this);
            $.get('/ajax/projects/state/' + element.attr('data-project-id'), function (data) {
                element.text(data);
            }, 'text');
        });
    };

    setInterval(refreshState, 2000);

    // ajax component parameters loader
    var paramsCount = 0;

    var clearParams = function () {
        paramsCount = 0;
        $('dd[role=param]').remove();
    };
    var addParam = function (name, description, value, required) {
        var paramKey = $('<input />', {
            type: 'text',
            className: 'param-name',
            name: 'param[' + paramsCount + '][name]'
        });
        if (name) paramKey.attr({readonly: 'readonly', value: name});
        if (required) paramKey.addClass('required');

        var paramValue = $('<input />', {
            type: 'text',
            className: 'param-value',
            name: 'param[' + paramsCount++ + '][value]'
        });
        if (value) paramValue.val(value);

        var descriptionBlock = $('<div></div>', {
            className: 'param-description hint',
            text: description
        });

        $('<dd></dd>', {className: 'field-edit param', role: 'param'})
            .append('Имя: ').append(paramKey)
            .append('Значение: ').append(paramValue)
            .append(descriptionBlock)
            .appendTo('dl[role=params]');
    };
    
    var loadParamsDefinition = function () {
        clearParams();
        $.getJSON('/ajax/components/parameters/' + $('option:selected', this).val(), function (data) {
            if (data.length === 0)
                $('<span></span>', {className: 'info', text: 'Отсутствуют'}).appendTo('dl[role=params]');

            for (var i = 0; i < data.length; i++)
                addParam(data[i].name, data[i].description, data[i]['default'], data[i].required)
        });
    };

    $('select[role=component]').change(loadParamsDefinition).change();

    $('[data-notimplemented=true]').click(function () {
        alert($(this).attr('data-notimplemented-text'));
        return false;
    });
});