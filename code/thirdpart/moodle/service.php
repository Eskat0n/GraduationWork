<?php

defined('MOODLE_INTERNAL') || die;

require_once("$CFG->libdir/externallib.php");
require_once("$CFG->libdir/filelib.php");

class moodle_sledgehammer_external extends external_api {

    public static function get_submissions_parameters() {
        return new external_function_parameters(
            array(
                'assignment' => new external_value(PARAM_RAW, ''),
                'from_time' => new external_value(PARAM_RAW, '')
            )
        );
    }

    public static function get_submissions($assignment, $from_time) {
        $params = self::validate_parameters(self::get_submissions_parameters(), array('assignment'=>$assignment, 'from_time'=>$from_time));

        global $DB;
        $query = 'SELECT * FROM {files} f WHERE EXISTS (SELECT * FROM {assignment_submissions} WHERE id = f.itemid and assignment = (SELECT id FROM {assignment} WHERE name = ?)) '.
                 'and component = \'mod_assignment\' and filearea = \'submission\' and filesize <> 0';

        if ($params['from_time'] != '')
            $query = $query.' and timemodified > ?';

        $submission_files = $DB->get_records_sql($query, array($params['assignment'], $params['from_time']));

        $submissions = array();
        foreach ($submission_files as $file) {
            $user = $DB->get_record('user', array('id' => $file->userid));

            $submissions[] = array(
                'id' => $file->id,
                'filename' => $file->filename,
                'username' => $user->lastname.' '.$user->firstname,
                'timemodified' => $file->timemodified
            );
        }

        return $submissions;
    }

    public static function get_submissions_returns() {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id' => new external_value(PARAM_INT, ''),
                    'filename' => new external_value(PARAM_TEXT, ''),
                    'username' => new external_value(PARAM_TEXT, ''),
                    'timemodified' => new external_value(PARAM_RAW, '')
                )
            )
        );
    }

    public static function get_submission_file_parameters() {
        return new external_function_parameters(
            array(
                'file_id' => new external_value(PARAM_INT, ''),
            )
        );
    }

    public static function get_submission_file($file_id) {
        $params = self::validate_parameters(self::get_submission_file_parameters(), array('file_id'=>$file_id));

        $fs = get_file_storage();
        $file = $fs->get_file_by_id($params['file_id']);

        if ($file) {
            $content = $file->get_content();
            $encoded_content = base64_encode($content);

            return array('content' => $encoded_content);
        } else {
            return null;
        }
    }

    public static function get_submission_file_returns() {
        return new external_single_structure(
            array(
                'content' => new external_value(PARAM_RAW, '')
            )
        );
    }
}