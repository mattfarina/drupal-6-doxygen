<?php
// $Id: example.profile,v 1.1.2.1 2010/03/15 21:25:17 jhodgdon Exp $

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *   An array of modules to enable.
 */
function example_profile_modules() {
  // This example profile enables the same optional modules as default.profile,
  // plus the 'locale' module. But however, any available modules may be added
  // to the list, including contributed modules, which will be then reqired by
  // the installer. Configuration of these modules may be handled later by tasks.
  return array('color', 'comment', 'help', 'menu', 'taxonomy', 'dblog', 'locale');
}

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile,
 *   and optional 'language' to override the language selection for
 *   language-specific profiles.
 */
function example_profile_details() {
  return array(
    // These two strings will be displayed on the initial profile-selecion
    // page, as a radio-button label, and description below. Because the
    // page is shown before language selection, there's no point to attempt
    // translation in any way; it's always shown in English. But however,
    // if the profile is focused to install Drupal in some other language,
    // these strings may be provided in that language, assuming that the
    // maintainer of the installed new Drupal site understands that better.
    // To skip the untranslatable profile-selection page entirely, ensure
    // that there's just one profile available, by deleting the default
    // profile.
    'name' => 'Example installation profile',
    'description' => 'This is an example installation profile for Drupal 6.x, demonstrating some of the principles to developers.',
    // This example profile is supposed to be language-focused, so we
    // inject the language selection here, hiding the language selection
    // screen from the user, and so saving one unnecessary, untranslatable
    // step. Any profile focused to features rather than language, or
    // expecting more languages to choose from, should omit the line below.
    // We're using Czech as an example here; it only works if a valid file
    // cs.po (with installer translations) is provided in the
    // profiles/example/translations directory, otherwise default English
    // will be used instead.
    'language' => 'cs',
  );
}

/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 *   A keyed array of tasks the profile will perform during
 *   the final stage. The keys of the array will be used internally,
 *   while the values will be displayed to the user in the installer
 *   task list.
 */
function example_profile_task_list() {
  return array(
    // Here we define names of the custom tasks we're about to perform,
    // so that these will be shown in the tasks list on the
    // installer UI. The keys may be anything (internal use only),
    // excepting the reserved tasks (as listed in install_reserved_tasks()
    // inside install.php). The strings may be translated with the st()
    // wrapper (translations provided in the install profile's .po file),
    // but sometimes there's no point in doing that, if the profile is
    // only focused to a single language. We only need to list tasks,
    // for which a page will be displayed; internally, unlisted keys
    // may be well used too. It's also possible to return dynamic data
    // here, adding/removing tasks on-the-fly depending on previous
    // steps.
    'task1' => st('Example question'),
    'task2' => st('Example summary'),
  );
}

/**
 * Perform any final installation tasks for this profile.
 *
 * The installer goes through the profile-select -> locale-select
 * -> requirements -> database -> locale-initial-batch -> configure
 * -> locale-remaining-batch -> finished -> done tasks in this order,
 * if you don't implement this function in your profile.
 *
 * If this function is implemented, you can have any number of
 * custom tasks to perform after 'configure', implementing a state
 * machine here to walk the user through those tasks. First time,
 * this function gets called with $task set to 'profile', and you
 * can advance to further tasks by setting $task to your tasks'
 * identifiers, used as array keys in the hook_profile_task_list()
 * above. You must avoid the reserved tasks listed in
 * install_reserved_tasks(). If you implement your custom tasks,
 * this function will get called in every HTTP request (for form
 * processing, printing your information screens and so on) until
 * you advance to the 'profile-finished' task, with which you
 * hand control back to the installer. Each custom page you
 * return needs to provide a way to continue, such as a form
 * submission or a link. You should also set custom page titles.
 *
 * You should define the list of custom tasks you implement by
 * returning an array of them in hook_profile_task_list(), as these
 * show up in the list of tasks on the installer user interface.
 *
 * Remember that the user will be able to reload the pages multiple
 * times, so you might want to use variable_set() and variable_get()
 * to remember your data and control further processing, if $task
 * is insufficient. Should a profile want to display a form here,
 * it can; the form should set '#redirect' to FALSE, and rely on
 * an action in the submit handler, such as variable_set(), to
 * detect submission and proceed to further tasks. See the configuration
 * form handling code in install_tasks() for an example.
 *
 * Important: Any temporary variables should be removed using
 * variable_del() before advancing to the 'profile-finished' phase.
 *
 * @param $task
 *   The current $task of the install system. When hook_profile_tasks()
 *   is first called, this is 'profile'.
 * @param $url
 *   Complete URL to be used for a link or form action on a custom page,
 *   if providing any, to allow the user to proceed with the installation.
 *
 * @return
 *   An optional HTML string to display to the user. Only used if you
 *   modify the $task, otherwise discarded.
 */
function example_profile_tasks(&$task, $url) {

  // First time, this function will be called with the 'profile' task.
  // In this case, we advance the pointer to our first custom task, to
  // indicate that this profile needs more runs to complete, and we
  // also perform some initial settings.
  if ($task == 'profile') {
    $task = 'task1';

    // The following part is a verbatim from default.profile, doing some
    // basic settings, that may be easily customized here. For a simple
    // profile, with no need for custom UI screens, this will be the
    // only code inside hook_profile_tasks(); in that case there's
    // no need to modify $task, as demonstrated in default.profile:
    // If $task is not changed, this function gets only called once.

    // Insert default user-defined node types into the database. For a complete
    // list of available node type attributes, refer to the node type API
    // documentation at: http://api.drupal.org/api/HEAD/function/hook_node_info.
    $types = array(
      array(
        'type' => 'page',
        'name' => st('Page'),
        'module' => 'node',
        'description' => st("A <em>page</em>, similar in form to a <em>story</em>, is a simple method for creating and displaying information that rarely changes, such as an \"About us\" section of a website. By default, a <em>page</em> entry does not allow visitor comments and is not featured on the site's initial home page."),
        'custom' => TRUE,
        'modified' => TRUE,
        'locked' => FALSE,
        'help' => '',
        'min_word_count' => '',
      ),
      array(
        'type' => 'story',
        'name' => st('Story'),
        'module' => 'node',
        'description' => st("A <em>story</em>, similar in form to a <em>page</em>, is ideal for creating and displaying content that informs or engages website visitors. Press releases, site announcements, and informal blog-like entries may all be created with a <em>story</em> entry. By default, a <em>story</em> entry is automatically featured on the site's initial home page, and provides the ability to post comments."),
        'custom' => TRUE,
        'modified' => TRUE,
        'locked' => FALSE,
        'help' => '',
        'min_word_count' => '',
      ),
    );

    foreach ($types as $type) {
      $type = (object) _node_type_set_defaults($type);
      node_type_save($type);
    }

    // Default page to not be promoted and have comments disabled.
    variable_set('node_options_page', array('status'));
    variable_set('comment_page', COMMENT_NODE_DISABLED);

    // Don't display date and author information for page nodes by default.
    $theme_settings = variable_get('theme_settings', array());
    $theme_settings['toggle_node_info_page'] = FALSE;
    variable_set('theme_settings', $theme_settings);

    // Update the menu router information.
    menu_rebuild();
  }
  // (End of verbatim from default.profile)

  // Our custom tasks now follow. Just like install.php, we use a construct
  // of if() statements here, to allow passing from one task to another in
  // the same request, after the $task pointer got modified, and ensure
  // that correct code gets executed on page reloads.

  // Our first custom task displays a form.
  if ($task == 'task1') {
    // FAPI takes care of most of the operations, as page reloads go.
    // We pass the $url to the form definition, to be used for form action.
    $output = drupal_get_form('example_form', $url);

    // The forms inside installer profiles may not use redirection, because
    // that will break the installer workflow. So we need an other way to
    // detect whether the form was successfully submitted, meaning that
    // the submit handler already performed it's job. This depends on the
    // exact use case; in this example profile, we check whether some
    // user-submitted text was already stored into our variable.
    if (!variable_get('example_submitted_text', FALSE)) {
      // The variable is still empty, meaning that the drupal_get_form()
      // call above haven't finished the form yet. We set a page-title
      // here, and return the rendered form to the installer, to be
      // shown to the user. Since $task is still set to 'task1', this
      // code will be re-run on next page request, proceeding further
      // if possible.
      drupal_set_title(st('Example question'));
      return $output;
    }
    else {
      // The form was submitted, so now we advance to the next task.
      $task = 'task2';
    }
  }

  // Our second custom task shows a simple page, summarizing the previous
  // step.
  if ($task == 'task2') {

    // To display a simple HTML page through the installer, we just set
    // title, and return the content. But since this code is now run on
    // every page request (until we change the $task), we need to detect
    // whether the user already decided to finish this task by clicking
    // to the provided link (as opposed to showing the page first time,
    // or a reload). This is done through an extra GET string added to
    // the link.
    if (empty($_GET['example_finished'])) {
      // The GET string is not present, meaning that this page request
      // is not coming from the link being clicked, and so we need to
      // render the page.
      $output = '<p>'. st('This page is a demonstration of custom page shown by a custom task of installer profile.') .'</p>';
      $output .= '<p>'. st('On the previous page, the following text was entered: %text.', array('%text' => variable_get('example_submitted_text', ''))) .'</p>';
      // We build the link from $url provided by the installer, adding
      // the extra GET string mentioned above.
      $output .= '<p><a href="'. $url .'&example_finished=yes">'. st('Click here to continue') .'</a></p>';
      drupal_set_title(st('Example summary'));
      return $output;
    }
    else {
      // The GET string is present, meaning that the user already
      // reviewed the page and clicked the link. We can advance to
      // further tasks now, but since we haven't any left, we just
      // finish our business here:

      // The variable 'example_submitted_text' was just a temporary
      // storage for our testing. Variables may be used for such
      // purposes here, but we should remove them before passing
      // control back to installer, to avoid leaving useless temporary
      // data in the variables table of the newly installed Drupal
      // site.
      variable_del('example_submitted_text');

      // By advancing to the 'profile-finished' task, we hand control
      // back to the installer, when we are done.
      $task = 'profile-finished';
    }
  }
}

/**
 * Form API array definition for the example form.
 */
function example_form(&$form_state, $url) {

    // This is just a very simple form with one textfield, and a
    // submit button.
    $form['example_text'] = array(
      '#type' => 'textfield',
      '#title' => st('Testing text'),
      '#default_value' => '',
      '#size' => 45,
      '#maxlength' => 45,
      '#required' => TRUE,
      '#description' => st('This is an example form demonstrating forms usage in the installer profiles tasks. Enter any text to see what happens.'),
    );

    $form['continue'] = array(
      '#type' => 'submit',
      '#value' => st('Continue'),
    );

    // Note that #action is set to the url passed through from
    // installer, ensuring that it points to the same page, and
    // #redirect is FALSE to avoid broken installer workflow.
    $form['errors'] = array();
    $form['#action'] = $url;
    $form['#redirect'] = FALSE;

  return $form;
}

/**
 * Form API submit for the example form.
 */
function example_form_submit($form, &$form_state) {

  // This code is executed, while the form is submitted. There's
  // a wide range of possible operations to execute here, such as
  // process and store settings, enable extra modules, or save
  // contents to the new site (unless the operations are too
  // expensive: the Batch API is a good choice for such operations,
  // but it needs to be coded inside hook_profile_tasks(), not
  // here).

  // In this example profile, we just store the submitted text to
  // a temporary variable, to be used in further tasks.
  variable_set('example_submitted_text', $form_state['values']['example_text']);
}

/**
 * Implementation of hook_form_alter().
 *
 * Allows the profile to alter the site-configuration form. This is
 * called through custom invocation, so $form_state is not populated.
 */
function example_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {

    // Here we can play with the site configuration form provided
    // by the installer, by changing the prepopulated $form array.
    // See install_configure_form() inside install.php for its
    // default content.

    // Set default for site name field.
    $form['site_information']['site_name']['#default_value'] = 'Drupal example';

    // Set default for administrator account name.
    $form['admin_account']['account']['name']['#default_value'] = 'admin';

    // Remove the timezone setting, as this profile is supposed to be
    // focused on Czech language as an example, where the timezone is
    // obvious.
    unset($form['server_settings']['date_default_timezone']);
    // Define the timezone as fixed value instead, so that the submit
    // handler of the site configuration form may still process it.
    $form['date_default_timezone'] = array(
      '#type' => 'value',
      '#value' => '3600',
    );
  }
}
