selected_features = ['game_title', 'esrb_rating', 'content_descriptors',
       'interactive_elements', 'content_summary', 'platform', 'release_date',
       'updated', 'developers', 'genres', 'release_year', 'publisher',
       'na_sales', 'eu_sales', 'jp_sales', 'other_sales', 'global_sales',
       'Number of Descriptors', 'Crude Humor', 'Mild Cartoon Violence',
       'Cartoon Violence', 'Mild Language', 'Mild Violence', 'Violence',
       'Blood and Gore', 'Language', 'Nudity', 'Sexual Themes',
       'Mild Fantasy Violence', 'Alcohol Reference', 'Mild Suggestive Themes',
       'Simulated Gambling', 'Fantasy Violence', 'Mild Blood',
       'Use of Alcohol', 'Use of Tobacco', 'Drug Reference', 'Strong Language',
       'Suggestive Themes', 'Blood', 'Partial Nudity', 'Tobacco Reference',
       'Comic Mischief', 'Animated Blood', 'Intense Violence',
       'Alcohol and Tobacco Reference', 'Violent References',
       'Strong Sexual Content', 'Use of Alcohol and Tobacco', 'Use of Drugs',
       'Mild Lyrics', 'Lyrics', 'Use of Drugs and Alcohol',
       'Animated Violence', 'Mild Sexual Themes', 'Sexual Content',
       'Drug and Alcohol Reference', 'Strong Lyrics', 'Mature Humor',
       'Edutainment', 'Gambling', 'Animated Blood and Gore', 'Informational',
       'Mature Sexual Themes', 'Mild Animated Violence', 'Gaming',
       'Realistic Violence', 'Realistic Blood', 'Suitable for Mature Users',
       'Gambling Themes', 'Realistic Blood and Gore', 'Sexual Violence',
       'Mild Realistic Violence', 'Suitable for All Users',
       'Mild Animated Blood', 'esrb_encoded']


selected_features = [ele for ele in selected_features if ele not in ['game_title', 'esrb_rating', 'content_descriptors',
       'interactive_elements', 'content_summary', 'platform', 'release_date',
       'updated', 'developers', 'genres', 'publisher',
       'na_sales', 'eu_sales', 'jp_sales', 'other_sales', 'global_sales',  'esrb_encoded']]

print(selected_features)