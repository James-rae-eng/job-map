import { Application } from '@hotwired/stimulus';
import * as Routes from '../routes';

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

window.Routes = Routes;
