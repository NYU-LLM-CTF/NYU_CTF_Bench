<?php

class Model_User extends \Orm\Model
{
	protected static $_properties = array(
		'id',
		'username',
		'password',
		'email',
		'nickname',
		'created_at',
		'updated_at',
	);

	protected static $_observers = array(
		'Orm\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'mysql_timestamp' => false,
		),
		'Orm\Observer_UpdatedAt' => array(
			'events' => array('before_update'),
			'mysql_timestamp' => false,
		),
	);
	protected static $_table_name = 'users';

    public static function make($val, $auth){

    }

    public static function validate_registration(Fieldset $form, $auth)
    {
        $form->field('password')->add_rule('match_value', $form->field('password2')->get_attribute('value'));
        $val = $form->validation();
        $val->set_message('required', 'The field :field is required');
        $val->set_message('valid_email', 'The field :field must be an email address');
        $val->set_message('match_value', 'The passwords must match');

        if ($val->run())
        {
            $username = $form->field('username')->get_attribute('value');
            $password = $form->field('password')->get_attribute('value');
            $email = $form->field('email')->get_attribute('value');
            $nickname = $form->field('nickname')->get_attribute('value');
            try
            {
                $user = $auth->create_user($username, $password, $email, $nickname);
            }
            catch (Exception $e)
            {
                $error = $e->getMessage();
            }
            if (isset($user))
            {
                $auth->login($username, $password);
            }
            else
            {
                if (isset($error))
                {
                    $li = $error;
                }
                else
                {
                    $li = 'Something went wrong with creating the user!';
                }
                $errors = Html::ul(array($li));
                return array('e_found' => true, 'errors' => $errors);
            }
        }
        else
        {
            $errors = $val->show_errors();
            return array('e_found' => true, 'errors' => $errors);
        }
    }
}
