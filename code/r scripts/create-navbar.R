########################################################
############## SCRIPT to generate navbar ###############
########################################################
setwd("C:/Users/nickb/Projects/1. Uncommon Sense/Website/code")

html <- ""
for (i in 1:nrow(rights)) {
  
  
  nav_issues <- archive %>%
    filter(Category == "Issues" & Right == tolower(rights$Right[i]))
  
  nav_solutions <- archive %>%
    filter(Category == "Solutions" & Right == tolower(rights$Right[i]))
  
  # Write html for each navigation item (right)
  html <- paste0(html,'
  <script>
  document.addEventListener("DOMContentLoaded", function() {
  const navbarList = document.querySelector(".navbar-nav.me-auto");

  if (navbarList) {
    const newItem = document.createElement("li");
    newItem.classList.add("nav-item", "dropdown");
    newItem.innerHTML = `
      <a class="nav-link dropdown-toggle" href="#" id="nav-menu-extra" role="link" data-bs-toggle="dropdown" aria-expanded="false">
        <span class="menu-text">',rights$Right[i],'</span>
      </a>
      <ul class="dropdown-menu two-column-dropdown" aria-labelledby="nav-menu-extra">
        <li><div class="dropdown-definition">',rights$DefinitionHTML[i],'</div></li>
        <li>
          <div class="dropdown-columns">
            <div class="dropdown-col">
              <div class="dropdown-header">Issues</div>

  ')
  
  # For each related issue 
  for (i in 1:nrow(nav_issues)) {
  if (nav_issues$Publish[i] == TRUE) {
  html <- paste0(html,  
              '<a class="dropdown-item" href="',nav_issues$Link[i],'">',nav_issues$Title[i] ,'</a>'
  )} else {
  html <- paste0(html,  
              '<div class="dropdown-item-unpublished">',nav_issues$Title[i],'</div>'
                   
  )}}
    
  # Static html
  html <- paste0(html,'  
            </div>
            <div class="dropdown-col">
            <div class="dropdown-header">Solutions</div>
  ')
  
  # For each related solution
  for (i in 1:nrow(nav_solutions)) {
  if (nav_solutions$Publish[i] == TRUE) {
  html <- paste0(html,  
              '<a class="dropdown-item" href="',nav_solutions$Link[i],'">',nav_solutions$Title[i] ,'</a>'
  )} else {
  html <- paste0(html,  
                 '<div class="dropdown-item-unpublished">',nav_solutions$Title[i],'</div>'
                   
  )}}

  # Static html
  html <- paste0(html,'  
              </div>
            </div>
          </li>
        </ul>
      `;
      navbarList.appendChild(newItem);
    }
  });
  </script>
  ')
}

# Write to html file
writeLines(html, "dev-navbar.html")

message("✅ navbar.html successfully generated.")

rm(nav_issues, nav_solutions)