<?php

class Controller_Admin extends Controller_Template
{

    public function action_b87e9bfdc06a086a3b8576a52c176a21()
    {
        $this->template->title = 'Admin - Secret';
        $this->template->content = View::forge('admin/index');
    }
}
