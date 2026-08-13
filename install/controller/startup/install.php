<?php
namespace Opencart\Install\Controller\Startup;
/**
 * Class Install
 *
 * @package Opencart\Install\Controller\Startup
 */
class Install extends \Opencart\System\Engine\Controller {
	/**
	 * Index
	 *
	 * @return void
	 */
	public function index(): void {
		// Document
		$this->registry->set('document', new \Opencart\System\Library\Document());

		// URL
		$this->registry->set('url', new \Opencart\System\Library\Url(HTTP_SERVER));

		// Language
		$this->config->set('language_code', 'it-it');

		$language = new \Opencart\System\Library\Language($this->config->get('language_code'));
		$language->addPath(DIR_LANGUAGE);
		$language->load('default');

		$this->registry->set('language', $language);
	}
}
