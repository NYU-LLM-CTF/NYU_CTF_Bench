import { FlowRouter } from 'meteor/kadira:flow-router';
import { BlazeLayout } from 'meteor/kadira:blaze-layout';

// Import to load these templates
import '../../ui/layouts/default/default.js';
import '../../ui/layouts/login/login.js';
import '../../ui/pages/home/home.js';

const isAuthenticatedRedirect = ( context, redirect, stop ) => {
  if (!Meteor.loggingIn() && !Meteor.userId()) {
    redirect('/login');
  }
};

const authRoutes = FlowRouter.group({
  name: 'isAuthenticated',
  triggersEnter: [ isAuthenticatedRedirect ]
});

const exposedRoutes = FlowRouter.group({
  name: 'exposed'
});

exposedRoutes.route('/login', {
  name: 'App.login',
  action() {
    BlazeLayout.render('Layout_login');
  },
});

authRoutes.route('/', {
  name: 'App.home',
  action() {
    BlazeLayout.render('Layout_default', { main: 'Home' });
  },
});