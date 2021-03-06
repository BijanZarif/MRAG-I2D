/*
 * RL_SmartyInline.h
 *
 *  Created on: Apr 4, 2012
 *      Author: mgazzola
 */

#ifndef RL_SMARTYINLINE_H_
#define RL_SMARTYINLINE_H_

#include "MRAGio/MRAG_IO_ArgumentParser.h"
#include "RL_Environment.h"
#include "RL_Agent.h"

namespace RL
{

class RL_SmartyInline : public RL_Agent
{
protected:
	Real dir[2];
	Real target[2];
	vector<int> signature;
	const Real D,T,maxDomainRadius;
	Real x,y,vx,vy,modv;

public:

	RL_SmartyInline(MRAG::ArgumentParser & parser, const Real _x, const Real _y, const Real _D, const Real _dir[2], const int _ID = 0, RL_TabularPolicy ** _policy = NULL, const int seed = 0);
	virtual ~RL_SmartyInline();

	virtual void update(const Real dt, const Real t, map< string, vector<RL_Agent *> > * _data = NULL, string filename = string());
	virtual void mapAction(int action);
	virtual bool mapState(vector<int> & state, map< string, vector<RL_Agent *> > * _data = NULL );
	virtual void reward(const Real t, map< string, vector<RL_Agent *> > * _data = NULL);

#ifdef _RL_VIZ
	virtual void paint();
#endif
};

} /* namespace RL */
#endif /* RL_SMARTYINLINE_H_ */
