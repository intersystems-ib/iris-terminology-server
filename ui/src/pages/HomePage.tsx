import { Link } from "react-router-dom";
import { TERMINOLOGIES } from "../config/demoConfig";

export function HomePage() {
  return (
    <main className="content-panel">
      <p className="eyebrow">Available Terminologies</p>
      <h2 className="section-title">Choose the demo path you want to show.</h2>
      <p className="section-copy">
        Start with one terminology, then move into its dedicated workspace. The next screen keeps the same terminology
        context while switching between native and FHIR execution models.
      </p>

      <div className="grid home-grid">
        {TERMINOLOGIES.map((terminology) => (
          <article key={terminology.id} className="card">
            <div className="card-top">
              <div>
                <h3>{terminology.name}</h3>
              </div>
              <span className="pill">{terminology.apiSupportLabel}</span>
            </div>

            <p>{terminology.subtitle}</p>

            <div className="card-meta">
              <div className="release-meta">
                <span className="release-label">Loaded release</span>
                <strong className="release-value">{terminology.releaseLabel}</strong>
              </div>
            </div>

            <div className="chip-row">
              {terminology.actions.map((action) => (
                <span key={action} className="chip">
                  {action}
                </span>
              ))}
            </div>

            <div className="button-row">
              <Link className="button button-primary" to={terminology.route}>
                Open Workspace
              </Link>
            </div>
          </article>
        ))}
      </div>
    </main>
  );
}
