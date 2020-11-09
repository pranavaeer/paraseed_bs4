#!/bin/usr/env bash

################################################################################
## Create new Paraseed BS4 Sub-Theme.
################################################################################
##
## Quick tip on how to use this script command file.
##
## Create new Paraseed BS4 sub theme for a project.
## By Bash:
## -----------------------------------------------------------------------------
## cd PROJECT_DIR_NAME/docroot/themes/contrib/paraseed_bs4/scripts
## bash ./create-new-paraseed-bs4.sh "THEME_NAME"
##------------------------------------------------------------------------------
##
##
################################################################################

# Basic yaml parser.
parse_yaml() {
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "",vn, $2, $3);
      }
   }'
}

current_path=$(pwd);
drupal_root="$current_path";

if [[ "${drupal_root: -1}" == "/" ]]; then
  drupal_root="${drupal_root:0:${#drupal_root}-1}";
fi

if [[ "${drupal_root: -35}" == "themes/contrib/paraseed_bs4/scripts" ]]; then
  drupal_root="${drupal_root:0:${#drupal_root}-35}";
fi

if [[ "${drupal_root: -27}" == "themes/contrib/paraseed_bs4" ]]; then
  drupal_root="${drupal_root:0:${#drupal_root}-27}";
fi

if [[ "${drupal_root: -6}" == "themes" ]]; then
  drupal_root="${drupal_root:0:${#drupal_root}-6}";
fi

if [[ "${drupal_root: -1}" == "/" ]]; then
  drupal_root="${drupal_root:0:${#drupal_root}-1}";
fi

echo "Current path: $current_path";
echo "Drupal root: $drupal_root";

# Read scripts.settings.yml file
eval $(parse_yaml $drupal_root/themes/contrib/paraseed_bs4/scripts/scripts.settings.yml);

# Default theme name.
theme_name=$default_theme_name;

# Grape the theme name argument.
if [ ! -z "$1" ]; then
  arg1="$1";
  if [[ $arg1 =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
    theme_name="$arg1";
  else
    echo "---------------------------------------------------------------------------";
    echo "   Theme name is not a valid theme name!                                   ";
    echo "---------------------------------------------------------------------------";
    exit 1;
  fi
else
  echo "---------------------------------------------------------------------------";
  echo "   Please add the name of your theme!                                      ";
  echo "---------------------------------------------------------------------------";
  exit 1;
fi


# Default themes creation path.
theme_path=$drupal_root/$default_themes_creation_path;
mkdir -p ${theme_path};

# Create the new Paraseed BS4 subtheme if we do not have a folder with that name yet.
if [[ ! -d "$theme_path/$theme_name" ]]; then

  # 1. Copy the PARASEED_BS4_SUBTHEME folder to your custom theme location.
  cp -r ${drupal_root}/themes/contrib/paraseed_bs4/PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name};

  # 2. Rename PARASEED_BS4_SUBTHEME.starterkit.yml your_subtheme_name.info.yml
  mv ${theme_path}/${theme_name}/PARASEED_BS4_SUBTHEME.starterkit.yml ${theme_path}/${theme_name}/PARASEED_BS4_SUBTHEME.info.yml ;
  mv ${theme_path}/${theme_name}/PARASEED_BS4_SUBTHEME.info.yml ${theme_path}/${theme_name}/${theme_name}.info.yml ;

  # 3. Rename PARASEED_BS4_SUBTHEME.libraries.yml your_subtheme_name.libraries.yml
  mv ${theme_path}/${theme_name}/PARASEED_BS4_SUBTHEME.libraries.yml ${theme_path}/${theme_name}/${theme_name}.libraries.yml ;

  # 4. Rename PARASEED_BS4_SUBTHEME.theme your_subtheme_name.theme
  mv ${theme_path}/${theme_name}/PARASEED_BS4_SUBTHEME.theme ${theme_path}/${theme_name}/${theme_name}.theme ;

  # 5. Rename PARASEED_BS4_SUBTHEME.settings.yml
  mv ${theme_path}/${theme_name}/config/install/PARASEED_BS4_SUBTHEME.settings.yml ${theme_path}/${theme_name}/config/install/${theme_name}.settings.yml ;

  # 6. Rename PARASEED_BS4_SUBTHEME.schema.yml
  mv ${theme_path}/${theme_name}/config/schema/PARASEED_BS4_SUBTHEME.schema.yml ${theme_path}/${theme_name}/config/schema/${theme_name}.schema.yml ;

  # 7. Rename PARASEED_BS4_SUBTHEME.base.scss and PARASEED_BS4_SUBTHEME.base.css
  mv ${theme_path}/${theme_name}/scss/base/PARASEED_BS4_SUBTHEME.base.scss ${theme_path}/${theme_name}/scss/base/${theme_name}.base.scss ;
  mv ${theme_path}/${theme_name}/css/base/PARASEED_BS4_SUBTHEME.base.css ${theme_path}/${theme_name}/css/base/${theme_name}.base.css ;

  # 8. Rename PARASEED_BS4_SUBTHEME-rtl.base.scss and PARASEED_BS4_SUBTHEME-rtl.base.css
  mv ${theme_path}/${theme_name}/scss/rtl/base/PARASEED_BS4_SUBTHEME-rtl.base.scss ${theme_path}/${theme_name}/scss/rtl/base/${theme_name}-rtl.base.scss ;
  mv ${theme_path}/${theme_name}/css/rtl/base/PARASEED_BS4_SUBTHEME-rtl.base.css ${theme_path}/${theme_name}/css/rtl/base/${theme_name}-rtl.base.css ;



  # 9 Rename TWIG template files.
  mv ${theme_path}/${theme_name}/templates/system/html.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/system/html.html.twig
  mv ${theme_path}/${theme_name}/templates/system/page.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/system/page.html.twig
  mv ${theme_path}/${theme_name}/templates/system/maintenance-page.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/system/maintenance-page.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/page--user--edit.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/page--user--edit.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/page--user--login.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/page--user--login.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/page--user--password.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/page--user--password.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/page--user--register.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/page--user--register.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/page--user--reset.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/page--user--reset.html.twig
  mv ${theme_path}/${theme_name}/templates/betterlogin/block--social-auth.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/betterlogin/block--social-auth.html.twig
  mv ${theme_path}/${theme_name}/templates/entity-embed/entity-embed-container.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/entity-embed/entity-embed-container.html.twig
  mv ${theme_path}/${theme_name}/templates/media/media.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/media/media.html.twig
  mv ${theme_path}/${theme_name}/templates/media/media--image.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/media/media--image.html.twig
  mv ${theme_path}/${theme_name}/templates/media/media-oembed-iframe.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/media/media-oembed-iframe.html.twig
  mv ${theme_path}/${theme_name}/templates/video-embed-field/video-embed-iframe.html.twig-PARASEED_BS4_SUBTHEME ${theme_path}/${theme_name}/templates/video-embed-field/video-embed-iframe.html.twig

  # 10 Rename config files.
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_branding.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_branding.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_breadcrumbs.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_breadcrumbs.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_content.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_content.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_copyright.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_copyright.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_footer.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_footer.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_help.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_help.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_local_actions.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_local_actions.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_local_tasks.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_local_tasks.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_main_menu.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_main_menu.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_messages.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_messages.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_page_title.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_page_title.yml
  mv ${theme_path}/${theme_name}/config/optional/block.block.PARASEED_BS4_SUBTHEME_socialauthlogin.yml ${theme_path}/${theme_name}/config/optional/block.block.${theme_name}_socialauthlogin.yml

  # 11. Replace all PARASEED_BS4_SUBTHEME with the machine name of your theme.
  grep -rl 'PARASEED_BS4_SUBTHEME' ${theme_path}/${theme_name} | xargs sed -i "s/PARASEED_BS4_SUBTHEME/${theme_name}/g" ;


  # 12. Install needed libraries
  cd ${theme_path}/${theme_name};
  npm install -g yarn ;
  yarn install ;

  generated_datetime="$(date '+%Y/%m/%d - %H:%M:%S')";
  generated_log=" Generated by -- create-new-paraseed ${theme_name} ${direction} ${theme_path} -- on ${generated_datetime}";
  echo "${generated_log}"  >> ${theme_path}/${theme_name}/README.md;

  echo "---------------------------------------------------------------------------";
  echo "   The new Paraseed BS4 Sub-Theme were created at \"${theme_path}/${theme_name} :)\" ";
  echo "---------------------------------------------------------------------------";
  exit 0;

else
  echo "---------------------------------------------------------------------------";
  echo "   The folder \"${theme_path}/${theme_name}\" is already in the site!";
  echo "---------------------------------------------------------------------------";
  exit 1;
fi
