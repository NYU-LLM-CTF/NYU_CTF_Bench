<?php
require('cryptutil.php');
class Controller_Users extends Controller_Template
{

    private function makeCookie($nickname, $id)
    {
        $date = @date_create();
        $timestamp = date_format($date, 'U');
        $cookie = "id=$id|nickname=$nickname|accestoadminpanel=false|timestamp=$timestamp";
        $crypter = new Cryptutil();
        $cipher_cookie = $crypter->encrypt(trim($cookie));
        Cookie::set('fuel_sess', $cipher_cookie);
    }

    private function updateCookie($nickname, $id)
    {
        Cookie::delete('fuel_sess');
        $date = @date_create();
        $timestamp = date_format($date, 'U');
        $cookie = "id=$id|nickname=$nickname|accestoadminpanel=false|timestamp=$timestamp";
        $crypter = new Cryptutil();
        $cipher_cookie = $crypter->encrypt(trim($cookie));
        Cookie::set('fuel_sess', $cipher_cookie);
        return $cookie;
    }

    public function action_index()
    {
        return Response::redirect('users/login');
    }

	public function action_login()
	{
        $view = View::forge('users/login');
        $auth = Auth::instance();

        if (Input::post())
        {
            if ($auth->login(Input::post('username'), Input::post('password')))
            {
                $id = $auth->get_user_id();
                $id = $id[1];
                $user = Model_User::find($id);
                $nickname = trim($user->nickname);
                $this->makeCookie($nickname, $id);
                Session::set_flash('success', 'Successfully logged in! Welcome '.$auth->get_screen_name());
                Response::redirect('users/home');
            }
            else
            {
                Session::set_flash('error', 'Username or password incorrect.');
                Response::redirect('users/login');
            }
        }
        $this->template->title = 'Login';
        $this->template->content = $view;
	}

	public function action_logout()
	{
        $auth = Auth::instance();
        $auth->logout();
        Session::set_flash('success', 'Logged out.');
        Cookie::delete('fuel_sess');
        Response::redirect('users/login');
	}

	public function action_register()
	{
        $auth = Auth::instance();
        $view = View::forge('users/register');

        if(Input::post())
        {
            $val = Validation::forge();

            $val->add('username', 'Username')
                ->add_rule('required');

            $val->add('password', 'Password')
                ->add_rule('required');

            $val->add('password2', 'Password2')
                ->add_rule('required');

            $val->add('email', 'Email')
                ->add_rule('required')
                ->add_rule('valid_email');

            $val->add('nickname', 'Nickname')
                ->add_rule('required');

            if($val->run())
            {
                $username = $val->validated('username');
                $password = $val->validated('password');
                $nickname = $val->validated('nickname');
                $email = $val->validated('email');

                try
                {
                    $auth->create_user($username, $password, $email);
                    $user = Model_User::find('first', array(
                        'where' => array(
                            array('username' => $username)
                        )
                    ));
                    $user->nickname = $nickname;
                    $user->save();
                    Session::set_flash('success', 'User created.');
                    Response::redirect('users/login');
                }
                catch(Exception $e)
                {
                    Session::set_flash('error', $e->getMessage());
                    Response::redirect('users/register');
                }
            }
            else
            {
                $errors = $val->error();

                Session::set_flash('error', 'Invalid data. Try again.');
                Response::redirect('users/register');
            }
        }

        $this->template->title = 'Register';
        $this->template->content = $view;
	}

    public function action_home()
    {
        $auth = Auth::instance();
        if(!$auth->check())
        {
            Response::redirect('users/login');
        }
        $cookie = Cookie::get('fuel_sess', null);
        if($cookie){
            $crypter = new Cryptutil();
            $plaintext_cookie = trim($crypter->decrypt($cookie));

            if(strpos($plaintext_cookie,'accestoadminpanel=true') !== false)
            {
                Response::redirect('admin/b87e9bfdc06a086a3b8576a52c176a21');
            }
        }
        $view = View::forge('users/home');
        $this->template->title = 'Home';
        $this->template->content = $view;

    }

    public function action_timesheets()
    {
        $auth = Auth::instance();
        if(!$auth->check())
        {
            Response::redirect('users/login');
        }
        if(Input::post())
        {
            Session::set_flash('success', 'Timesheet submitted. Thank you!');
            Response::redirect('users/home');
        }

        $view = View::forge('users/timesheets');
        $this->template->title = 'Timesheets';
        $this->template->content = $view;
    }

    public function action_profile()
    {
        $auth = Auth::instance();
        if(!$auth->check())
        {
            Response::redirect('users/login');
        }

        if(Input::post())
        {
            $messages = array();
            if(Input::post('password', 'password2'))
            {
                $oldpassword = Input::post('password');
                $newpassword = Input::post('password2');
                if(Auth::change_password($oldpassword,$newpassword))
                {
                    array_push($messages, 'Password Changed!');
                }
                else
                {
                    Session::set_flash('error', 'Invalid password.  ');
                }
            }

            if(Input::post('email'))
            {
                array_push($messages, 'Email Changed!');
            }

            if(Input::post('nickname'))
            {
                $nickname = Input::post('nickname');
                $id = $auth->get_user_id();
                $id = $id[1];
                $user = Model_User::find($id);
                $user->nickname = $nickname;
                $user->save();
                $this->updateCookie($nickname, $id);
                array_push($messages, 'Nickname Changed!');
            }
            Session::set_flash('success', $messages);
            Response::redirect('users/home');
        }

        $email = Input::post('email');

        $view = View::forge('users/profile');
        $this->template->title = 'Update Profile';
        $this->template->content = $view;
    }

}
