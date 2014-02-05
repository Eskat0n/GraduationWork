<?php

// === sledgehammer service functions ===

function import_sledgehammer_functions($functions) {
    $functions['moodle_sledgehammer_get_submissions'] = array(
        'classname'   => 'moodle_sledgehammer_external',
        'methodname'  => 'get_submissions',
        'classpath'   => 'sledgehammer/service.php',
        'description' => 'Get list of all submission files for particular assignment',
        'type'        => 'read',
        'capabilities'=> ''
    );

    $functions['moodle_sledgehammer_get_submission_file'] = array(
        'classname'   => 'moodle_sledgehammer_external',
        'methodname'  => 'get_submission_file',
        'classpath'   => 'sledgehammer/service.php',
        'description' => 'Get submission file content as base64 encoded string',
        'type'        => 'read',
        'capabilities'=> ''
    );

    return $functions;
}
