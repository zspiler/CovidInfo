import UIKit
import Charts


class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var casesSwitch: UISwitch!
    @IBOutlet weak var hospSwitch: UISwitch!
    @IBOutlet weak var vaccSwitch: UISwitch!
    @IBOutlet weak var deathsSwitch: UISwitch!
    @IBOutlet weak var regionsSwitch: UISwitch!
    @IBOutlet weak var vaccByAgeSwitch: UISwitch!
    @IBOutlet weak var vaccPopularitySwitch: UISwitch!

    
    let userDefaults = UserDefaults.standard
    
    @IBAction func hospSwitchChanged(_ sender: Any) {
        if (hospSwitch.isOn) {
            userDefaults.set(true, forKey: HOSP_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: HOSP_SWITCH_KEY)
        }
    }
    
    @IBAction func casesSwitchChanged(_ sender: Any) {
        if (casesSwitch.isOn) {
            userDefaults.set(true, forKey: CASES_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: CASES_SWITCH_KEY)
        }
    }
    
    @IBAction func vaccSwitchChanged(_ sender: Any) {
        if (vaccSwitch.isOn) {
            userDefaults.set(true, forKey: VACC_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: VACC_SWITCH_KEY)
        }
    }
    
    @IBAction func vaccPopularitySwitchChanged(_ sender: Any) {
        if (vaccPopularitySwitch.isOn) {
            userDefaults.set(true, forKey: VACCPOPULARITY_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: VACCPOPULARITY_SWITCH_KEY)
        }
    }
    
    @IBAction func deathsSwitchChanged(_ sender: Any) {
        if (deathsSwitch.isOn) {
            userDefaults.set(true, forKey: DEATHS_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: DEATHS_SWITCH_KEY)
        }
    }
    
    @IBAction func regionsSwitchChanged(_ sender: Any) {
        if (regionsSwitch.isOn) {
            userDefaults.set(true, forKey: REGIONS_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: REGIONS_SWITCH_KEY)
        }
        
    }
    
    @IBAction func vaccByAgeSwitchChanged(_ sender: Any) {
        if (vaccByAgeSwitch.isOn) {
            userDefaults.set(true, forKey: VACCBYAGE_SWITCH_KEY)
        } else {
            userDefaults.set(false, forKey: VACCBYAGE_SWITCH_KEY)
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultPreferences()
        setSwitches()
    }
    
    
    func setDefaultPreferences() {
        if (userDefaults.object(forKey: CASES_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: CASES_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: HOSP_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: HOSP_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: VACC_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: VACC_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: DEATHS_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: DEATHS_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: REGIONS_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: REGIONS_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: VACCBYAGE_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: VACCBYAGE_SWITCH_KEY)
        }
        if (userDefaults.object(forKey: VACCPOPULARITY_SWITCH_KEY) == nil) {
            userDefaults.set(true, forKey: VACCPOPULARITY_SWITCH_KEY)
        }
      
    }
    
    
    func setSwitches() {
        if (userDefaults.bool(forKey: CASES_SWITCH_KEY)) {
            casesSwitch.setOn(true, animated: false)
        }
        else {
            casesSwitch.setOn(false, animated: true)
        }
        
        if (userDefaults.bool(forKey: HOSP_SWITCH_KEY)) {
            hospSwitch.setOn(true, animated: false)
        }
        else {
            hospSwitch.setOn(false, animated: true)
        }
        
        if (userDefaults.bool(forKey: VACC_SWITCH_KEY)) {
            vaccSwitch.setOn(true, animated: false)
        }
        else {
            vaccSwitch.setOn(false, animated: true)
        }
        
        if (userDefaults.bool(forKey: DEATHS_SWITCH_KEY)) {
            deathsSwitch.setOn(true, animated: false)
        }
        else {
            deathsSwitch.setOn(false, animated: true)
        }
        
        if (userDefaults.bool(forKey: REGIONS_SWITCH_KEY)) {
            regionsSwitch.setOn(true, animated: false)
        }
        else {
            regionsSwitch.setOn(false, animated: true)
        }

        if (userDefaults.bool(forKey: VACCBYAGE_SWITCH_KEY)) {
            vaccByAgeSwitch.setOn(true, animated: false)
        }
        else {
            vaccByAgeSwitch.setOn(false, animated: true)
        }
        
        if (userDefaults.bool(forKey: VACCPOPULARITY_SWITCH_KEY)) {
            vaccPopularitySwitch.setOn(true, animated: false)
        }
        else {
            vaccPopularitySwitch.setOn(false, animated: true)
        }
    }
    
    
}

